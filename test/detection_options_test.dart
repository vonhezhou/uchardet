import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:uchardet/src/charset_prober.dart';
import 'package:uchardet/src/escape_charset_prober.dart';
import 'package:uchardet/src/mbcs_group_prober.dart';
import 'package:uchardet/src/sbcs_group_prober.dart';
import 'package:uchardet/src/utf8_validator.dart';
import 'package:uchardet/uchardet.dart';

Uint8List fixture(String path) =>
    File('tools/test_data/$path').readAsBytesSync();

Object snapshot(List<CharSetCandidate> candidates) => [
  for (final c in candidates) (c.encoding, c.language, c.confidence, c.hasBom),
];

void main() {
  group('candidate encodings', () {
    final samples = {
      'zh/utf-8.txt': Encoding.utf8,
      'zh/gb18030.txt': Encoding.gb18030,
      'zh/big5.txt': Encoding.big5,
      'ja/shift_jis.txt': Encoding.shiftJIS,
      'ja/euc-jp.txt': Encoding.eucJP,
      'ko/uhc.smi': Encoding.uhc,
      'ko/johab.txt': Encoding.johab,
      'fr/windows-1252.txt': Encoding.windows1252,
      'ru/koi8-r.txt': Encoding.koi8R,
      'he/windows-1255.txt': Encoding.windows1255,
      'he/ibm862.visual.txt': Encoding.ibm862,
      'ja/iso-2022-jp.txt': Encoding.iso2022JP,
      'ko/iso-2022-kr.txt': Encoding.iso2022KR,
    };
    for (final entry in samples.entries) {
      test('detects ${entry.key} with only its encoding allowed', () {
        final detector = UCharDet(
          options: UCharDetOptions(candidateEncodings: {entry.value}),
        );
        final candidates = detector.detect(fixture(entry.key));
        expect(candidates, isNotEmpty);
        expect(candidates.map((c) => c.encoding), everyElement(entry.value));
      });
    }

    test('Hebrew direction inference respects the allowed output encoding', () {
      final logical = fixture('he/windows-1255.txt');
      final visual = Uint8List.fromList(logical.reversed.toList());
      final detector = UCharDet(
        options: const UCharDetOptions(
          candidateEncodings: {Encoding.iso_8859_8},
        ),
      );
      expect(detector.detect(visual).single.encoding, Encoding.iso_8859_8);
      // 白名单不能把逻辑顺序的 Windows-1255 强行改报为视觉顺序编码。
      expect(detector.detect(logical), isEmpty);
    });

    test('excluded probers cannot end the competition early', () {
      final japanese = fixture('ja/shift_jis.txt');
      final mbcs = MBCSGroupProber(
        languageFilter: LanguageFilter.all,
        candidateEncodings: {Encoding.utf8},
      );
      expect(mbcs.feed(japanese), isNot(ProberState.foundIt));

      final sbcs = SBCSGroupProber(candidateEncodings: {Encoding.utf8});
      final russian = fixture('ru/windows-1251.txt');
      for (var i = 0; i < 10; i++) {
        expect(sbcs.feed(russian), isNot(ProberState.foundIt));
      }

      final escape = EscapeCharSetProber(
        langFilter: LanguageFilter.all,
        candidateEncodings: {Encoding.iso2022KR},
      );
      expect(
        escape.feed(fixture('ja/iso-2022-jp.txt')),
        isNot(ProberState.foundIt),
      );
      escape.close();
      expect(escape.getCandidates(), isEmpty);
    });

    test('empty allowlist rejects guesses, including ASCII and NBSP', () {
      final detector = UCharDet(
        options: const UCharDetOptions(candidateEncodings: {}),
      );
      for (final bytes in [
        Uint8List.fromList('ABC'.codeUnits),
        Uint8List.fromList([65, 0xa0]),
        fixture('zh/utf-8.txt'),
        fixture('fr/windows-1252.txt'),
        fixture('ja/iso-2022-jp.txt'),
      ]) {
        expect(detector.detect(bytes), isEmpty);
      }
    });

    test('BOM declaration survives allowlist conflicts at every split', () {
      final boms = {
        Encoding.utf8: [0xef, 0xbb, 0xbf],
        Encoding.utf16le: [0xff, 0xfe],
        Encoding.utf16be: [0xfe, 0xff],
        Encoding.utf32le: [0xff, 0xfe, 0, 0],
        Encoding.utf32be: [0, 0, 0xfe, 0xff],
      };
      for (final entry in boms.entries) {
        final bytes = Uint8List.fromList([...entry.value, 65, 0, 0, 0]);
        for (var split = 0; split <= bytes.length; split++) {
          final detector = UCharDet(
            options: const UCharDetOptions(candidateEncodings: {}),
          );
          detector.feed(Uint8List.sublistView(bytes, 0, split));
          detector.feed(Uint8List.sublistView(bytes, split));
          detector.close();
          expect(detector.candidates.single.encoding, entry.key);
          expect(detector.candidates.single.hasBom, isTrue);
        }
      }
    });

    test('language filter and allowlist both apply', () {
      final detector = UCharDet(
        options: UCharDetOptions(
          languageFilter: LanguageFilter.some([
            LanguageFilterType.kChineseSimplified,
          ]),
          candidateEncodings: {Encoding.shiftJIS},
        ),
      );
      expect(detector.detect(fixture('ja/shift_jis.txt')), isEmpty);
    });

    test('copies allowlist and retains it across reset and detect', () {
      final allowed = {Encoding.big5};
      final detector = UCharDet(
        options: UCharDetOptions(candidateEncodings: allowed),
      );
      allowed
        ..clear()
        ..add(Encoding.utf8);
      for (var i = 0; i < 2; i++) {
        detector.reset();
        expect(
          detector.detect(fixture('zh/big5.txt')).first.encoding,
          Encoding.big5,
        );
      }
    });

    test('weights cannot bring excluded encodings back', () {
      final detector = UCharDet(
        options: const UCharDetOptions(candidateEncodings: {Encoding.big5}),
      );
      detector.setDefaultWeight(100);
      detector.detect(fixture('zh/big5.txt'));
      detector.weighLanguage(Language.chinese, 200);
      expect(detector.candidates, isNotEmpty);
      expect(
        detector.candidates.map((c) => c.encoding),
        everyElement(Encoding.big5),
      );
    });
  });

  group('independent UTF8 validation', () {
    test('disabled by default, pending until close when enabled', () {
      final unchecked = UCharDet();
      unchecked.detect(Uint8List.fromList([0xff]));
      expect(unchecked.utf8Validity, Utf8Validity.notChecked);

      final detector = UCharDet(
        options: const UCharDetOptions(validateUtf8: true),
      );
      expect(detector.utf8Validity, Utf8Validity.pending);
      detector.feed(Uint8List.fromList([65]));
      expect(detector.utf8Validity, Utf8Validity.pending);
      detector.close();
      expect(detector.utf8Validity, Utf8Validity.valid);
      detector.reset();
      expect(detector.utf8Validity, Utf8Validity.pending);
      detector.close();
      expect(detector.utf8Validity, Utf8Validity.valid);
    });

    final cases = <String, List<int>>{
      'empty': [],
      'ASCII and zero bytes': [0, 65, 127],
      'scalar boundaries': utf8.encode(
        String.fromCharCodes([
          0x80,
          0x7ff,
          0x800,
          0xd7ff,
          0xe000,
          0xffff,
          0x10000,
          0x10ffff,
        ]),
      ),
      'short mixed text': utf8.encode('é中😀'),
      'BOM then malformed payload': [0xef, 0xbb, 0xbf, 0xff],
      'isolated continuation': [0x80],
      'two-byte overlong': [0xc0, 0x80],
      'three-byte overlong': [0xe0, 0x9f, 0xbf],
      'four-byte overlong': [0xf0, 0x8f, 0xbf, 0xbf],
      'surrogate': [0xed, 0xa0, 0x80],
      'out of range': [0xf4, 0x90, 0x80, 0x80],
      'invalid leader': [0xf5, 0x80, 0x80, 0x80],
      'truncated two-byte': [0xc2],
      'truncated three-byte': [0xe4, 0xb8],
      'truncated four-byte': [0xf0, 0x90, 0x80],
      'ASCII instead of continuation': [0xc2, 65],
    };
    for (final entry in cases.entries) {
      test('${entry.key} agrees with strict SDK decoder at every split', () {
        final bytes = Uint8List.fromList(entry.value);
        final expected = _sdkValidity(bytes);
        for (var split = 0; split <= bytes.length; split++) {
          final detector = UCharDet(
            options: const UCharDetOptions(validateUtf8: true),
          );
          detector.feed(Uint8List.sublistView(bytes, 0, split));
          detector.feed(Uint8List(0));
          detector.feed(Uint8List.sublistView(bytes, split));
          detector.close();
          expect(detector.utf8Validity, expected, reason: 'split=$split');
          detector.close();
          expect(detector.utf8Validity, expected);
        }
      });
    }

    test('continues validation after BOM has ended encoding detection', () {
      final detector = UCharDet(
        options: const UCharDetOptions(validateUtf8: true),
      );
      expect(detector.feed(Uint8List.fromList([0xef, 0xbb, 0xbf])), isTrue);
      expect(detector.utf8Validity, Utf8Validity.pending);
      detector.feed(Uint8List.fromList([0xe4, 0xb8]));
      detector.close();
      expect(detector.utf8Validity, Utf8Validity.invalid);
      expect(detector.candidates.single.hasBom, isTrue);
      detector.detect(Uint8List.fromList([65]));
      expect(detector.utf8Validity, Utf8Validity.valid);
    });

    test('validation is independent of allowlist and language scores', () {
      final detector = UCharDet(
        options: const UCharDetOptions(
          validateUtf8: true,
          candidateEncodings: {},
        ),
      );
      expect(detector.detect(Uint8List.fromList(utf8.encode('😀42'))), isEmpty);
      expect(detector.utf8Validity, Utf8Validity.valid);
    });

    test('enabling validation preserves candidates and confidence', () {
      for (final path in [
        'zh/utf-8.txt',
        'fr/windows-1252.txt',
        'he/iso-8859-8.txt',
        'ja/iso-2022-jp.txt',
      ]) {
        final bytes = fixture(path);
        final expected = snapshot(UCharDet().detect(bytes));
        final detector = UCharDet(
          options: const UCharDetOptions(validateUtf8: true),
        );
        expect(snapshot(detector.detect(bytes)), expected);
        expect(detector.utf8Validity, _sdkValidity(bytes));
      }
    });

    test('random byte streams agree with SDK across chunk boundaries', () {
      final random = Random(13);
      final validator = Utf8Validator();
      for (var i = 0; i < 2000; i++) {
        final bytes = Uint8List.fromList(
          List.generate(random.nextInt(24), (_) => random.nextInt(256)),
        );
        validator.reset();
        for (final byte in bytes) {
          validator.feed(Uint8List.fromList([byte]));
        }
        validator.close();
        expect(validator.validity, _sdkValidity(bytes), reason: '$bytes');
      }
    });
  });
}

Utf8Validity _sdkValidity(Uint8List bytes) {
  try {
    utf8.decode(bytes);
    return Utf8Validity.valid;
  } on FormatException {
    return Utf8Validity.invalid;
  }
}
