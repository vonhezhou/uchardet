import 'dart:convert';
import 'dart:typed_data';

import 'package:uchardet/uchardet.dart';

// 每个新进程只测首次检测，将共享索引初始化计入耗时。
void main() {
  final bytes = Uint8List.fromList(
    utf8.encode(
      'La détection des caractères français est utile pour lire les documents. ' *
          48,
    ),
  );
  final watch = Stopwatch()..start();
  final candidates = UCharDet().detect(bytes);
  watch.stop();
  print(
    jsonEncode({
      'microseconds': watch.elapsedMicroseconds,
      'candidates': candidates.length,
    }),
  );
}
