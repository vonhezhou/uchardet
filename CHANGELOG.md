## Unreleased

- Reduce multibyte slicing, filter-buffer and candidate allocations; share ASCII
  model lookups and batch candidate weighting without changing detection results.
- Add VM/AOT/JavaScript benchmarks, allocation profiling and full-result snapshots.

- Verify parity with upstream `06029ec3340cdf6bf9a6a537dafb3f39eda0560e`
  (official master on 2026-11-02). No newer detector/model changes are present;
  upstream CLI default weighting is supported through `setDefaultWeight()`.

- Fix detector reuse, BOM handling across chunks, and UTF-8 early detection.
- Restore shared MBCS filtering and prevent out-of-range multibyte slices.
- Add per-language and default confidence weights, retained across resets.
- Correct generated encoding assertions and add port regression coverage.

## 0.0.8

- Initial version.
