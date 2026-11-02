# 性能基准

基准提交为 `c22fd82`，对比同一份测试驱动和 SDK 下的优化实现。
完整测量值、环境和分配计数保存在 [results.json](results.json)。

## 测量方式

- `uchardet_benchmark.dart` 覆盖 ASCII、UTF-8 法文/中文、Shift-JIS、Latin-1，输入约 1–4 KiB。
- `fresh` 每次创建探测器；`reuse` 复用实例；`chunk64` / `chunk1` 分别按 64 / 1 字节分块。
- 每项预热 150 ms，再测 5 轮，每轮至少 100 ms，取每次操作耗时的中位数。
- 仅比较相同输入、分块方式的优化前后耗时。探测可能提前结束，不把整个输入长度当作实际处理量计算吞吐率。
- `cold_start.dart` 在新进程内测量首次 UTF-8 检测，包含模型索引初始化，不包含进程启动；交替运行两个版本各 10 次取中位数。
- `profile_allocations.dart` 在预热后，对同一个探测器执行固定 500 次检测，使用 VM service 统计累计分配。该数据不等于进程常驻内存。
- 性能测试串行运行。耗时受硬件、SDK、JIT 和系统负载影响，不用固定耗时阈值作为 CI 正确性断言。

## 运行

在基准提交的独立 checkout 中复制同一份 `benchmark/` 和 profiling 工具，使用相同依赖及 SDK 运行；先完成编译，再串行测量两个版本。

```sh
# JIT
dart run benchmark/uchardet_benchmark.dart

# AOT
dart compile exe benchmark/uchardet_benchmark.dart -o /tmp/uchardet-bench
/tmp/uchardet-bench

# 只测一项，便于定位回退
/tmp/uchardet-bench shift-jis/chunk64

# JavaScript（Node）
dart compile js -O2 benchmark/uchardet_benchmark.dart -o /tmp/uchardet-bench.js
node /tmp/uchardet-bench.js

# 首次检测；每次运行均启动新进程
dart compile exe benchmark/cold_start.dart -o /tmp/uchardet-cold
/tmp/uchardet-cold

# 本机 VM 累计分配；JSON 位于输出最后一行
dart --enable-vm-service=0 tools/profile_allocations.dart
```

## 正确性约束

`tools/detection_snapshot.dart` 输出 158 个样本 × 4 种分块 × 2 种权重的 1,264 组快照。
每组包含完整候选顺序、编码、语言、置信度、BOM，以及 `feed()` 提前结束位置。
对比的是优化前 Dart 行为，上游已有的分块敏感性保持不变。

```sh
dart run tools/detection_snapshot.dart > /tmp/before.json
# 切换至优化版本后
dart run tools/detection_snapshot.dart > /tmp/after.json
cmp /tmp/before.json /tmp/after.json

# 可在 AOT 和 JS 中分别与对应基准版本比较完整结果
dart run benchmark/results_snapshot.dart
```

AOT / JS 的 20 组基准输入快照也分别与同运行环境的基准版本逐项一致。

## 内存与兼容性取舍

- 每个语言模型的 ASCII 索引为 128 个 `Int32`，在同一 isolate 内共享；原始模型保留 `const List`，不在每个实例中复制整套模型。
- 过滤暂存区的实例复用上限为 64 KiB，超出上限的输入使用一次性缓冲区，避免大输入永久撑大实例占用。过滤结果是内部借用视图，由 prober 同步消费。
- 公开 API、候选列表行为、权重语义和排序保持兼容；内部字符分析改为直接接收两个字节。
- 有收益的批量计数和共享查找被保留；极细分块的固定调用成本仍需结合实际负载评估。完整测量包含所有用例，而非仅列出提升项。

## 本次测量结果

环境：Dart 3.13.7、macOS arm64；JS 使用 v26.13.0 的 Node。数值为单次操作的中位耗时，单位 µs。

| 用例（复用实例、整段输入） | AOT 优化前 → 后 | JIT 提速 | JS 提速 |
|---|---:|---:|---:|
| ascii | 8.2 → 8.1 | 1.01× | 1.02× |
| utf8-fr | 3339.9 → 1275.1 | 2.66× | 1.82× |
| utf8-zh | 1455.5 → 402.5 | 2.55× | 3.21× |
| shift-jis | 16.9 → 10.1 | 1.84× | 4.72× |
| latin1 | 2966.1 → 1191.5 | 2.75× | 1.82× |

首次 UTF-8 检测（AOT）为 4220.5 → 1602.5 µs，模型初始化成本已计入。

保留的取舍：`shift-jis/chunk1` 的 AOT 耗时为 386.0 → 434.6 µs（增加 12.6%）。64 字节分块改善，JIT/JS 逐字节用例也改善。批量计数对极细 AOT 调用存在额外固定成本；为此另设一套重复探测规则会增加维护风险，本次保留单一规则实现并记录这项回退。

固定 500 次检测的累计分配：

| 对象 | 优化前数量 | 优化后数量 | 减少 |
|---|---:|---:|---:|
| _Uint8List | 80,716 | 1,870 | 97.7% |
| CharSetCandidate | 43,632 | 2,687 | 93.8% |

原有无效 `AssertionError(...)` 已修正为 `assert(...)`；在本次预热分配统计中原实现也没有实际分配该类对象，因此不把这一修正计为性能收益。
