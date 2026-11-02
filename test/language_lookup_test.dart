import 'package:test/test.dart';
import 'package:uchardet/src/internal_types.dart';
import 'package:uchardet/src/language_detector.dart';
import 'package:uchardet/uchardet.dart';

const _model = LanguageModel(
  mLanguage: Language.french,
  mCharOrderTable: [65, 0, 66, 1, 256, 0, 257, 1],
  mPrecedenceMatrix: [3, 2, 0, 3],
  mFreqCharCount: 2,
  mVeryFreqCharCount: 1,
  veryFreqRatio: 0.5,
  mLowFreqOrder: 0,
  mLowFreqRatio: 0.5,
);

void main() {
  test(
    'ASCII and equivalent Unicode letters have the same sequence confidence',
    () {
      final ascii = LanguageDetector(mModel: _model)..feed([65, 65, 66, 66]);
      final unicode = LanguageDetector(mModel: _model)
        ..feed([256, 256, 257, 257]);
      expect(ascii.getConfidence(), unicode.getConfidence());
      expect(ascii.getConfidence(), greaterThan(0));
    },
  );

  test(
    'missing codepoints inside and outside the model remain foreign letters',
    () {
      final inside = LanguageDetector(mModel: _model)
        ..feed([65, 65, 67, 66, 66]);
      final outside = LanguageDetector(mModel: _model)
        ..feed([65, 65, 300, 66, 66]);
      final clean = LanguageDetector(mModel: _model)..feed([65, 65, 66, 66]);
      expect(inside.getConfidence(), outside.getConfidence());
      expect(inside.getConfidence(), lessThan(clean.getConfidence()));
    },
  );

  test('shared model lookup does not share mutable detection state', () {
    final first = LanguageDetector(mModel: _model)..feed([65, 65, 66, 66]);
    final expected = first.getConfidence();
    final second = LanguageDetector(mModel: _model)..feed([66, 65, 66, 65]);
    expect(second.getConfidence(), isNot(expected));
    expect(first.getConfidence(), expected);
    first.reset();
    first.feed([65, 65, 66, 66]);
    expect(first.getConfidence(), expected);
  });
}
