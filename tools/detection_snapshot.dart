import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:uchardet/uchardet.dart';

// 将完整结果和提前结束位置保存为 JSON，供重构前后逐项对照。
void main() {
  final files =
      Directory(
          'tools/test_data',
        ).listSync(recursive: true).whereType<File>().toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  final results = <Object>[];
  for (final weighted in [false, true]) {
    for (final chunk in [0, 1, 7, 64]) {
      final detector = UCharDet();
      if (weighted) {
        detector.setDefaultWeight(0.5);
        detector.weighLanguage(Language.french, 2);
      }
      for (final file in files) {
        final bytes = file.readAsBytesSync();
        detector.reset();
        var consumed = 0;
        var done = false;
        if (chunk == 0) {
          done = detector.feed(bytes);
          consumed = bytes.length;
        } else {
          for (var start = 0; start < bytes.length; start += chunk) {
            consumed = (start + chunk).clamp(0, bytes.length);
            done = detector.feed(Uint8List.sublistView(bytes, start, consumed));
            if (done) break;
          }
        }
        detector.close();
        results.add([
          file.path,
          chunk,
          weighted,
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
  }
  stdout.writeln(jsonEncode(results));
}
