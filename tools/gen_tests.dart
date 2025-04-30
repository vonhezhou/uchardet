import 'dart:io';

import 'package:path/path.dart' as p;

void main() {
  final dir = Directory('./tools/test_data/');
  final outputDir = './test/';
  final outputFile = File('$outputDir/uchardet_test.dart');

  final testCode = generateTestCode(dir);

  outputFile.writeAsStringSync(testCode);
  print('Test file generated: $outputFile');
}

String generateTestCode(Directory dir) {
  final testCode = StringBuffer();
  testCode.writeln('// GENERATED FILE - DO NOT EDIT');
  testCode.writeln("import 'dart:typed_data';");
  testCode.writeln();
  testCode.writeln("import 'package:test/test.dart';");
  testCode.writeln("import 'package:uchardet/uchardet.dart';");
  testCode.writeln();

  testCode.writeln('void main() {');
  testCode.writeln('  group(\'uchardet\', () {');
  testCode.writeln('    setUp(() {});');

  for (var entity in dir.listSync(recursive: true)) {
    if (entity is! File) {
      continue;
    }

    final file = entity;
    final parentDir = file.parent;
    final languageCode = p.basename(parentDir.path);
    final encodingName = removeSuffix(p.basenameWithoutExtension(file.path));

    // skip some known to fail test as the origin repo do
    if (languageCode == 'es' && encodingName == "iso-8859-15" ||
        languageCode == 'da' && encodingName == "iso-8859-1" ||
        languageCode == 'he' && encodingName == "iso-8859-8") {
      continue;
    }

    testCode.writeln();
    testCode.writeln('    test(\'detect $languageCode $encodingName\', () {');
    testCode.writeln(
      '      final detector = UCharDet();',
    );

    final content = file.readAsBytesSync();
    final hexList = content
        .map((byte) => '0x${byte.toRadixString(16).padLeft(2, '0')}')
        .join(', ');

    final argName =
        'k${toPascalCase(languageCode)}${toPascalCase(encodingName)}';
    testCode.writeln('      // dart format off');
    testCode.writeln('      final $argName = Uint8List.fromList([$hexList]);');
    testCode.writeln('      // dart format on');
    testCode.writeln('      final candidates = detector.detect($argName);');
    testCode.writeln('      expect(candidates.isNotEmpty, isTrue);');
    testCode.writeln(
      "      expect(candidates.first.encoding.name.toLowerCase(), equals('${encodingName.toLowerCase()}'));",
    );

    // for these encoding, languane is not reliably detected
    if (!encodingName.startsWith("ascii") &&
        !encodingName.startsWith("utf-16") &&
        !encodingName.startsWith("utf-32")) {
      testCode.writeln(
        "      expect(candidates.first.language?.iso6391Code, equals('${languageCode.toLowerCase()}'));",
      );
    }

    testCode.writeln('    });');
  }

  testCode.writeln('  });'); // group
  testCode.writeln('}'); // main
  return testCode.toString();
}

String removeSuffix(String input) {
  return input.split('.').first;
}

/// convert input to pascal case
/// removing all non-alphanumeric characters
String toPascalCase(String input) {
  final regex = RegExp(r'[^a-zA-Z0-9]');
  final newInput = input.replaceAll(regex, ''); 
  final words = newInput.split(' ');
  final capitalizedWords = words.map((word) {
    if (word.isEmpty) return '';
    final firstLetter = word.substring(0, 1).toUpperCase();
    final restOfWord = word.substring(1).toLowerCase();
    return '$firstLetter$restOfWord';
  });
  return capitalizedWords.join();
}
