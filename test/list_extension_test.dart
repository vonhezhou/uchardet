import 'package:test/test.dart';
import 'package:uchardet/src/base/list_extensions.dart';

void main() {
  group('List extension tests', () {
    const prefix = [1, 2, 3, 4, 5];

    const testList1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    const testList2 = [1, 2, 3];
    const testList3 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    setUp(() {
      // Additional setup goes here.
    });

    test('List.startsWith Test', () {
      expect(testList1.startsWith(prefix), isTrue);
      expect(testList2.startsWith(prefix), isFalse);
      expect(testList3.startsWith(prefix), isFalse);
      expect([].startsWith(prefix), isFalse);
      expect(testList1.startsWith([]), isTrue);
      expect([].startsWith([]), isTrue);
    });
  });
}
