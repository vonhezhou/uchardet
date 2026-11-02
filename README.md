<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages). 
-->

A Dart port of the [uchardet](https://gitlab.freedesktop.org/uchardet/uchardet) library, providing character encoding detection capabilities for Dart applications.

Since only the functionality of dart:core is used, should work  on all platforms.

## Features

- Detects various character encodings from text data.
- Supports a wide range of encodings, including UTF-8, UTF-16, ISO-8859-1, and more. Check Encoding enum for a complete list.
- Supports detecting a range of languages. Check Language enum for a complete list.
- Easy-to-use API for integrating encoding detection into your Dart projects.

## Usage

```dart
import 'dart:typed_data';

import 'package:uchardet/uchardet.dart';

void main() {
  final detector = UCharDet(options: UCharDetOptions());
  // dart format off
  final utf8CN = Uint8List.fromList([ 0xE4, 0xB8, 0xAD, 0xE5, 0x8D, 0xB1, 0xE4, 0xBA, 0x8B, 0xE6, 0x96, 0x87, 0xE5, 0x8C, 0x97, 0xE5, 0x92, 0x8C, 0xE5, 0x9B, 0x9B, ]);
  // dart format on

  // for one-off detection
  printAllCanditates(detector.detect(utf8CN));
  // or access it from detector.candidates
  printAllCanditates(detector.candidates);

  // feed() can be called multiple times
  detector.reset();
  for (var ii in utf8CN) {
    if (detector.feed(Uint8List.fromList([ii]))) {
      break;
    }
  }
  detector.close();
  printAllCanditates(detector.candidates);
}

void printAllCanditates(List<CharSetCandidate> candidates) {
  if (candidates.isEmpty) {
    print('No candidates');
  } else {
    for (var ii in candidates) {
      print(ii);
    }
  }
}

```

## Language weights

Language weights provide the functionality of upstream `uchardet_weigh_language`
and `uchardet_set_default_weight`. They adjust candidate confidence and ranking
without changing which probers run or the minimum-confidence filtering.

```dart
final detector = UCharDet();
detector.setDefaultWeight(0.5);
detector.weighLanguage(Language.french, 2.0);
final candidates = detector.detect(bytes);

// 已有结果也可立即按新权重重新排序。
detector.weighLanguage(Language.french, 1.0);
print(detector.candidates);
```

Weights default to `1.0` and must be finite, non-negative numbers. An explicit
language weight replaces the default weight for that language; candidates with
no language use the default. The reported confidence is the original confidence
multiplied by the weight, so it can exceed `1.0`. A zero weight keeps the candidate
with confidence `0.0`. Changing weights recalculates from the original confidence,
without accumulating multipliers. Both `reset()` and `detect()` retain weights.
Unlike the pinned C++ version, the default weight also takes effect when no
per-language weight has been set.

To regenerate the sample tests:

```sh
dart run tools/gen_tests.dart
dart format test/uchardet_test.dart
```

## Additional information

- the detection is NOT 100% accurate
- inherited single-byte filtering heuristics can produce different results for
  different chunk boundaries; use one buffer when consistent results are required
- the sample fixtures adapt the pinned upstream corpus: Japanese UTF-16 samples
  have BOMs added, and the GB18030 and UHC samples differ from the upstream files
- certain encodings, e.g. utf-16, will not detect languange
- utf-16/utf-32 without BOM will NOT be detected
- upstream baseline: [06029ec3340cdf6bf9a6a537dafb3f39eda0560e](https://gitlab.freedesktop.org/uchardet/uchardet/-/commit/06029ec3340cdf6bf9a6a537dafb3f39eda0560e),
  verified against official `master` on 2026-11-02. The detection core, language
  models and test fixtures are unchanged from the original `edae8e81` baseline.
  The newer CLI default-language-weight option is covered by `setDefaultWeight()`;
  its file-handle and MSVC fixes do not require Dart library changes.

## Supported Languages/Encodings

- International (Unicode)
  - UTF-8
  - UTF-16BE / UTF-16LE
  - UTF-32BE / UTF-32LE
- Arabic
  - UTF-8
  - ISO-8859-6
  - WINDOWS-1256
- Belarusian
  - UTF-8
  - ISO-8859-5
  - WINDOWS-1251
- Bulgarian
  - UTF-8
  - ISO-8859-5
  - WINDOWS-1251
- Catalan
  - UTF-8
  - ISO-8859-1
  - WINDOWS-1252
- Chinese
  - UTF-8
  - ISO-2022-CN
  - BIG5
  - EUC-TW
  - GB18030
  - HZ-GB-2312
- Croatian:
  - UTF-8
  - ISO-8859-2
  - ISO-8859-13
  - ISO-8859-16
  - Windows-1250
  - IBM852
  - MAC-CENTRALEUROPE
- Czech
  - UTF-8
  - Windows-1250
  - ISO-8859-2
  - IBM852
  - MAC-CENTRALEUROPE
- Danish
  - UTF-8
  - IBM865
  - ISO-8859-1
  - ISO-8859-15
  - WINDOWS-1252
- English
  - UTF-8
  - ASCII
- Esperanto
  - UTF-8
  - ISO-8859-3
- Estonian
  - UTF-8
  - ISO-8859-4
  - ISO-8859-13
  - ISO-8859-15
  - Windows-1252
  - Windows-1257
- Finnish
  - UTF-8
  - ISO-8859-1
  - ISO-8859-4
  - ISO-8859-9
  - ISO-8859-13
  - ISO-8859-15
  - WINDOWS-1252
- French
  - UTF-8
  - ISO-8859-1
  - ISO-8859-15
  - WINDOWS-1252
- German
  - UTF-8
  - ISO-8859-1
  - WINDOWS-1252
- Georgian
  - UTF-8
  - GEORGIAN-ACADEMY
  - GEORGIAN-PS
- Greek
  - UTF-8
  - ISO-8859-7
  - WINDOWS-1253
  - CP737
- Hebrew
  - UTF-8
  - ISO-8859-8
  - WINDOWS-1255
  - IBM862
- Hindi
  - UTF-8
- Hungarian:
  - UTF-8
  - ISO-8859-2
  - WINDOWS-1250
- Irish Gaelic
  - UTF-8
  - ISO-8859-1
  - ISO-8859-9
  - ISO-8859-15
  - WINDOWS-1252
- Italian
  - UTF-8
  - ISO-8859-1
  - ISO-8859-3
  - ISO-8859-9
  - ISO-8859-15
  - WINDOWS-1252
- Japanese
  - UTF-8
  - ISO-2022-JP
  - SHIFT_JIS
  - EUC-JP
- Korean
  - UTF-8
  - ISO-2022-KR
  - EUC-KR / UHC
  - Johab
- Latvian
  - UTF-8
  - ISO-8859-4
  - ISO-8859-10
  - ISO-8859-13
- Lithuanian
  - UTF-8
  - ISO-8859-4
  - ISO-8859-10
  - ISO-8859-13
- Maltese
  - UTF-8
  - ISO-8859-3
- Macedonian
  - UTF-8
  - ISO-8859-5
  - WINDOWS-1251
  - IBM855
- Norwegian
  - UTF-8
  - IBM865
  - ISO-8859-1
  - ISO-8859-15
  - WINDOWS-1252
- Polish:
  - UTF-8
  - ISO-8859-2
  - ISO-8859-13
  - ISO-8859-16
  - Windows-1250
  - IBM852
  - MAC-CENTRALEUROPE
- Portuguese
  - UTF-8
  - ISO-8859-1
  - ISO-8859-9
  - ISO-8859-15
  - WINDOWS-1252
- Romanian:
  - UTF-8
  - ISO-8859-2
  - ISO-8859-16
  - Windows-1250
  - IBM852
- Russian
  - UTF-8
  - ISO-8859-5
  - KOI8-R
  - WINDOWS-1251
  - MAC-CYRILLIC
  - IBM866
  - IBM855
- Serbian
  - UTF-8
  - ISO-8859-5
  - WINDOWS-1251
- Slovak
  - UTF-8
  - Windows-1250
  - ISO-8859-2
  - IBM852
  - MAC-CENTRALEUROPE
- Slovene
  - UTF-8
  - ISO-8859-2
  - ISO-8859-16
  - Windows-1250
  - IBM852
  - MAC-CENTRALEUROPE
- Spanish
  - UTF-8
  - ISO-8859-1
  - ISO-8859-15
  - WINDOWS-1252
- Swedish
  - UTF-8
  - ISO-8859-1
  - ISO-8859-4
  - ISO-8859-9
  - ISO-8859-15
  - WINDOWS-1252
- Thai
  - UTF-8
  - TIS-620
  - ISO-8859-11
- Turkish:
  - UTF-8
  - ISO-8859-3
  - ISO-8859-9
- Ukrainian:
  - UTF-8
  - WINDOWS-1251
- Vietnamese:
  - UTF-8
  - VISCII
  - Windows-1258
- Others
  - WINDOWS-1252
