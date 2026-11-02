import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:uchardet/uchardet.dart';

void main() {
  group('uchardet more test', () {
    test('uchardet detect utf8', () {
      final detector = UCharDet();
      final buffer = Uint8List.fromList([0xEF, 0xBB, 0xBF, 0x41, 0x61]);
      final candidates = detector.detect(buffer);
      expect(candidates.isNotEmpty, isTrue);
      expect(candidates.first.encoding, equals(Encoding.utf8));
      expect(candidates.first.language, equals(null));
    });

    test('uchardet detect utf16le', () {
      final detector = UCharDet();
      // FF FE  UTF-16, little endian BOM
      final buffer = Uint8List.fromList([0xFF, 0xFE, 0x41, 0x61]);
      final candidates = detector.detect(buffer);
      expect(candidates.isNotEmpty, isTrue);
      expect(candidates.first.encoding, equals(Encoding.utf16le));
      expect(candidates.first.language, equals(null));
    });

    test('uchardet detect utf16be', () {
      final detector = UCharDet();
      // FE FF  UTF-16, big endian BOM
      final buffer = Uint8List.fromList([0xFE, 0xFF, 0x41, 0x61]);
      final candidates = detector.detect(buffer);
      expect(candidates.isNotEmpty, isTrue);
      expect(candidates.first.encoding, equals(Encoding.utf16be));
      expect(candidates.first.language, equals(null));
    });

    test('uchardet detect utf32le', () {
      final detector = UCharDet();
      /* FF FE 00 00: UTF-32 (LE). */
      final buffer = Uint8List.fromList([0xFF, 0xFE, 0x00, 0x00, 0x41, 0x61]);
      final candidates = detector.detect(buffer);
      expect(candidates.isNotEmpty, isTrue);
      expect(candidates.first.encoding, equals(Encoding.utf32le));
      expect(candidates.first.language, equals(null));
    });

    test('uchardet detect utf32be', () {
      final detector = UCharDet();
      /* 00 00 FE FF: UTF-32 (BE). */
      final buffer = Uint8List.fromList([0x00, 0x00, 0xFE, 0xFF, 0x41, 0x61]);
      final candidates = detector.detect(buffer);
      expect(candidates.isNotEmpty, isTrue);
      expect(candidates.first.encoding, equals(Encoding.utf32be));
      expect(candidates.first.language, equals(null));
    });

    test('uchardet detect pure ascii', () {
      final detector = UCharDet();
      final buffer = Uint8List.fromList([0x41, 0x42, 0x43, 0x44, 0x45]);
      final candidates = detector.detect(buffer);
      expect(candidates.isNotEmpty, isTrue);
      expect(candidates.first.encoding, equals(Encoding.ascii));
      expect(candidates.first.language, equals(null));
    });

    test('uchardet detect empty data', () {
      final detector = UCharDet();
      final buffer = Uint8List(0);
      final candidates = detector.detect(buffer);
      expect(candidates.isEmpty, isTrue);
    });

    test('non-UTF8 bytes can still match a legacy encoding', () {
      final detector = UCharDet();
      final buffer = Uint8List.fromList([0xff, 0xff, 0xff, 0xff, 0xff, 0x01]);
      final candidates = detector.detect(buffer);
      // 上游将此输入判为 WINDOWS-1251；编码探测不等同于文本合法性校验。
      expect(candidates.first.encoding, Encoding.windows1251);
      expect(candidates.first.language, Language.russian);
    });
  });
}
