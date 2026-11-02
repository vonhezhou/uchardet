import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:uchardet/src/charset_prober.dart';
import 'package:uchardet/src/eucjp_prober.dart';
import 'package:uchardet/src/utf8_prober.dart';
import 'package:uchardet/uchardet.dart';

Uint8List fixture(String path) =>
    File('tools/test_data/$path').readAsBytesSync();

List<Object> snapshot(List<CharSetCandidate> candidates) => [
  for (final c in candidates) (c.encoding, c.language, c.confidence, c.hasBom),
];

void main() {
  group('detector reuse', () {
    test('clears BOM and received-data state', () {
      final detector = UCharDet();
      expect(
        detector
            .detect(Uint8List.fromList([0xef, 0xbb, 0xbf, 65]))
            .single
            .encoding,
        Encoding.utf8,
      );
      expect(
        detector
            .detect(Uint8List.fromList([0xff, 0xfe, 65, 0]))
            .single
            .encoding,
        Encoding.utf16le,
      );
      expect(detector.detect(Uint8List(0)), isEmpty);
      detector.reset();
      detector.close();
      expect(detector.candidates, isEmpty);
    });

    test('replaces UTF8 language candidates on each detection', () {
      final detector = UCharDet();
      for (final name in ['zh/utf-8.txt', 'fr/utf-8.txt', 'zh/utf-8.txt']) {
        final bytes = fixture(name);
        final expected = snapshot(UCharDet().detect(bytes));
        expect(snapshot(detector.detect(bytes)), expected);
      }
    });

    test('UTF8 reset removes candidates and close is idempotent', () {
      final prober = UTF8Prober();
      prober.feed(fixture('fr/utf-8.txt'));
      prober.close();
      final expected = snapshot(prober.getCandidates());
      expect(expected, isNotEmpty);
      prober.close();
      expect(snapshot(prober.getCandidates()), expected);
      prober.reset();
      expect(prober.getCandidates(), isEmpty);
    });
  });

  group('BOM boundaries', () {
    final boms = <Encoding, List<int>>{
      Encoding.utf8: [0xef, 0xbb, 0xbf],
      Encoding.utf16le: [0xff, 0xfe],
      Encoding.utf16be: [0xfe, 0xff],
      Encoding.utf32le: [0xff, 0xfe, 0, 0],
      Encoding.utf32be: [0, 0, 0xfe, 0xff],
    };
    for (final entry in boms.entries) {
      for (final payload in [
        <int>[],
        [65, 0, 0, 0],
      ]) {
        test(
          '${entry.key} with ${payload.length} payload bytes at every split',
          () {
            final bytes = Uint8List.fromList([...entry.value, ...payload]);
            // 枚举每个字节间隙是否切块，覆盖 BOM 本身及 BOM 后正文的所有边界。
            for (var mask = 0; mask < 1 << (bytes.length - 1); mask++) {
              final detector = UCharDet();
              detector.feed(Uint8List(0));
              var start = 0;
              for (var end = 1; end <= bytes.length; end++) {
                if (end == bytes.length || mask & (1 << (end - 1)) != 0) {
                  detector.feed(Uint8List.sublistView(bytes, start, end));
                  detector.feed(Uint8List(0));
                  start = end;
                }
              }
              detector.close();
              final candidate = detector.candidates.single;
              expect(candidate.encoding, entry.key, reason: 'split mask $mask');
              expect(candidate.hasBom, isTrue);
              expect(candidate.language, isNull);
              expect(candidate.confidence, 1.0);
            }
          },
        );
      }
    }

    test('waits for the fourth byte of an ambiguous UTF32LE BOM', () {
      final detector = UCharDet();
      expect(detector.feed(Uint8List.fromList([0xff, 0xfe, 0])), isFalse);
      expect(detector.feed(Uint8List.fromList([0])), isTrue);
      detector.close();
      expect(detector.candidates.single.encoding, Encoding.utf32le);
    });

    test('replays a short non-BOM prefix exactly once at end', () {
      final detector = UCharDet();
      detector.feed(Uint8List.fromList([65]));
      detector.feed(Uint8List.fromList([0xa0]));
      detector.close();
      expect(detector.candidates.single.encoding, Encoding.iso_8859_1);
      final expected = snapshot(detector.candidates);
      detector.close();
      expect(snapshot(detector.candidates), expected);
    });
  });

  group('multibyte probing', () {
    test(
      'UTF8 short circuit wins before single-byte probers consume the input',
      () {
        final bytes = Uint8List.fromList(utf8.encode('中' * 300));
        final detector = UCharDet();
        expect(detector.feed(bytes), isTrue);
        detector.close();
        expect(detector.candidates.first.encoding, Encoding.utf8);
        expect(detector.candidates.first.language, Language.chinese);
        expect(detector.candidates.first.confidence, 0.99);
      },
    );

    for (final prefix in ['\nABCD', 'ABCD\n', '\t\r\nABCD']) {
      test('Big5 ignores ASCII prefix ${prefix.codeUnits}', () {
        final detector = UCharDet();
        final bytes = Uint8List.fromList([
          ...prefix.codeUnits,
          ...fixture('zh/big5.txt'),
        ]);
        final candidates = detector.detect(bytes);
        expect(candidates.first.encoding, Encoding.big5);
        expect(candidates.first.language, Language.chinese);
        expect(candidates.first.confidence, 1.0);
      });
    }

    test('Big5 filter keeps its trailing-ASCII count across feed calls', () {
      final bytes = fixture('zh/big5.txt');
      final detector = UCharDet();
      detector.feed(Uint8List.fromList([...bytes, 32]));
      detector.feed(Uint8List.fromList([32, 10, 65, 66, 67, 68]));
      detector.feed(bytes);
      detector.close();
      expect(detector.candidates.first.encoding, Encoding.big5);
    });

    test('EUC-JP three-byte characters do not create invalid slices', () {
      final bytes = Uint8List.fromList([0x8f, 0xa2, 0xaf]);
      for (var split = 0; split <= bytes.length; split++) {
        final prober = EUCJPProber(true);
        prober.feed(Uint8List.sublistView(bytes, 0, split));
        prober.feed(Uint8List.sublistView(bytes, split));
        expect(prober.getState(), ProberState.detecting);
        // 统计器只关心双字节字符，不应将三字节字符计入频率。
        expect(prober.getCandidates().single.confidence, 0.01);
      }
      expect(() => UCharDet().detect(bytes), returnsNormally);
    });

    for (final size in [1, 2, 3, 7]) {
      test('EUC-TW supports chunks of $size bytes', () {
        final bytes = fixture('zh/euc-tw.txt');
        final detector = UCharDet();
        for (var start = 0; start < bytes.length; start += size) {
          final end = (start + size).clamp(0, bytes.length);
          if (detector.feed(Uint8List.sublistView(bytes, start, end))) break;
        }
        detector.close();
        expect(detector.candidates.first.encoding, Encoding.eucTW);
        expect(detector.candidates.first.language, Language.chinese);
      });
    }
  });

  group('language weights', () {
    test('reorders existing candidates without accumulating multipliers', () {
      final detector = UCharDet();
      final bytes = fixture('fr/utf-8.txt');
      final original = detector.detect(bytes).toList();
      final catalan = original.firstWhere(
        (c) => c.language == Language.catalan,
      );
      detector.weighLanguage(Language.catalan, 2);
      expect(detector.candidates.first.language, Language.catalan);
      expect(detector.candidates.first.confidence, catalan.confidence * 2);
      expect(detector.candidates.length, original.length);
      detector.weighLanguage(Language.catalan, 3);
      expect(detector.candidates.first.confidence, catalan.confidence * 3);
      detector.weighLanguage(Language.catalan, 1);
      expect(snapshot(detector.candidates), snapshot(original));
    });

    test(
      'default and per-language weights persist across reset and detect',
      () {
        final detector = UCharDet();
        final bytes = fixture('fr/utf-8.txt');
        final original = detector.detect(bytes).toList();
        detector.setDefaultWeight(0.5);
        detector.weighLanguage(Language.catalan, 2);
        final expected = snapshot(detector.candidates);
        for (final c in detector.candidates) {
          final raw = original.firstWhere(
            (r) => r.encoding == c.encoding && r.language == c.language,
          );
          expect(
            c.confidence,
            raw.confidence * (c.language == Language.catalan ? 2 : 0.5),
          );
        }
        detector.reset();
        expect(detector.candidates, isEmpty);
        expect(snapshot(detector.detect(bytes)), expected);
      },
    );

    test(
      'default weight applies without language overrides and preserves BOM',
      () {
        final detector = UCharDet()..setDefaultWeight(0.25);
        final candidates = detector.detect(
          Uint8List.fromList([0xef, 0xbb, 0xbf]),
        );
        expect(candidates.single.confidence, 0.25);
        expect(candidates.single.hasBom, isTrue);
        expect(candidates.single.language, isNull);
      },
    );

    test(
      'weights apply after confidence filtering and keep zero-weight candidates',
      () {
        final bytes = fixture('fr/utf-8.txt');
        final detector = UCharDet(
          options: UCharDetOptions(minConfidence: 0.95),
        );
        final original = detector.detect(bytes).toList();
        expect(original, isNotEmpty);
        detector.setDefaultWeight(0);
        detector.weighLanguage(Language.english, 100);
        expect(detector.candidates.length, original.length);
        expect(detector.candidates.every((c) => c.confidence == 0), isTrue);
        final expected = snapshot(detector.candidates);
        expect(snapshot(detector.detect(bytes)), expected);
      },
    );

    test('rejects invalid weights without changing existing results', () {
      final detector = UCharDet();
      detector.detect(fixture('fr/utf-8.txt'));
      final original = snapshot(detector.candidates);
      for (final weight in [-1.0, double.nan, double.infinity]) {
        expect(() => detector.setDefaultWeight(weight), throwsArgumentError);
        expect(
          () => detector.weighLanguage(Language.french, weight),
          throwsArgumentError,
        );
      }
      expect(snapshot(detector.candidates), original);
    });
  });
}
