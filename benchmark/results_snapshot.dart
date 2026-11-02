import 'dart:convert';
import 'dart:typed_data';

import 'package:uchardet/uchardet.dart';

import 'uchardet_benchmark.dart' show benchmarkInputs;

// 与计时分离，验证 VM/AOT/JS 的完整候选及提前结束位置。
void main() {
  final results = <Object>[];
  for (final entry in benchmarkInputs().entries) {
    for (final chunk in [0, 1, 7, 64]) {
      final detector = UCharDet();
      var consumed = 0;
      var done = false;
      final size = chunk == 0 ? entry.value.length : chunk;
      for (var start = 0; start < entry.value.length; start += size) {
        consumed = (start + size).clamp(0, entry.value.length);
        done = detector.feed(
          Uint8List.sublistView(entry.value, start, consumed),
        );
        if (done) break;
      }
      detector.close();
      results.add([
        entry.key,
        chunk,
        consumed,
        done,
        [
          for (final c in detector.candidates)
            [
              c.encoding.name,
              c.language?.name,
              c.confidence.isFinite ? c.confidence : c.confidence.toString(),
              c.hasBom,
            ],
        ],
      ]);
    }
  }
  print(jsonEncode(results));
}
