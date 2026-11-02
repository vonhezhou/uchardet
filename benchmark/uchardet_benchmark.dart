import 'dart:convert' show jsonEncode, utf8;
import 'dart:typed_data';

import 'package:uchardet/uchardet.dart';

// 不依赖 dart:io，可在 VM、AOT 和 dart2js/Node 中运行。
Map<String, Uint8List> benchmarkInputs() => {
  'ascii': Uint8List.fromList(
    ('The quick brown fox jumps over the lazy dog. ' * 96).codeUnits,
  ),
  'utf8-fr': Uint8List.fromList(
    utf8.encode(
      'La détection des caractères français est utile pour lire les documents. ' *
          48,
    ),
  ),
  'utf8-zh': Uint8List.fromList(utf8.encode('中文字符编码检测和语言分析。' * 96)),
  'shift-jis': Uint8List.fromList(
    List.generate(
      96,
      (_) => [0x82, 0xb1, 0x82, 0xf1, 0x82, 0xc9, 0x82, 0xbf, 0x82, 0xcd, 32],
    ).expand((b) => b).toList(),
  ),
  'latin1': Uint8List.fromList(
    ('La détection des caractères français est utile pour lire les documents. ' *
            48)
        .codeUnits,
  ),
};

int consume(UCharDet detector, Uint8List bytes, int chunkSize) {
  detector.reset();
  if (chunkSize == 0) {
    detector.feed(bytes);
  } else {
    for (var start = 0; start < bytes.length; start += chunkSize) {
      final end = (start + chunkSize).clamp(0, bytes.length);
      if (detector.feed(Uint8List.sublistView(bytes, start, end))) break;
    }
  }
  detector.close();
  return detector.candidates.length;
}

int _checksum = 0;

void main(List<String> arguments) {
  final results = <String, Object>{};
  for (final entry in benchmarkInputs().entries) {
    for (final mode in ['fresh', 'reuse', 'chunk64', 'chunk1']) {
      if (arguments.isNotEmpty &&
          !'${entry.key}/$mode'.contains(arguments.first)) {
        continue;
      }
      final detector = UCharDet();
      final chunk =
          mode == 'chunk64'
              ? 64
              : mode == 'chunk1'
              ? 1
              : 0;
      void run() {
        _checksum += consume(
          mode == 'fresh' ? UCharDet() : detector,
          entry.value,
          chunk,
        );
      }

      final warmup = Stopwatch()..start();
      while (warmup.elapsedMilliseconds < 150) {
        run();
      }
      final samples = <double>[];
      for (var sample = 0; sample < 5; sample++) {
        var iterations = 0;
        final watch = Stopwatch()..start();
        do {
          run();
          iterations++;
        } while (watch.elapsedMilliseconds < 100);
        samples.add(watch.elapsedMicroseconds / iterations);
      }
      samples.sort();
      results['${entry.key}/$mode'] = samples[2];
    }
  }
  print(
    jsonEncode({
      'unit': 'microseconds/operation',
      'median': results,
      'checksum': _checksum,
    }),
  );
}
