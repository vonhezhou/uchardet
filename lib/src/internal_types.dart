/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is Mozilla Universal charset detector code.
 *
 * The Initial Developer of the Original Code is
 * Netscape Communications Corporation.
 * Portions created by the Initial Developer are Copyright (C) 2001
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *          von <vonhezhou@gmail.com>: dart port
 *          Kohei TAKETA <k-tak@void.in>
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

import './types.dart';

/// Codepoints *
/* Illegal codepoints.*/
// ignore: constant_identifier_names
const ILL = 255;
/* Control character. */
// ignore: constant_identifier_names
const CTR = 254;
/* Symbols and punctuation that does not belong to words. */
// ignore: constant_identifier_names
const SYM = 253;
/* Return/Line feeds. */
// ignore: constant_identifier_names
const RET = 252;
/* Numbers 0-9. */
// ignore: constant_identifier_names
const NUM = 251;

class SequenceModel {
  /* [256] table mapping codepoints to chararacter orders. */
  final List<int> mCharToOrderMap;

  /* freqCharCount x freqCharCount table of 2-char sequence's frequencies. */
  final List<int> mPrecedenceMatrix;

  /* The count of frequent characters. */
  final int mFreqCharCount;
  final double mTypicalPositiveRatio; // = freqSeqs / totalSeqs
  // says if this script contains English characters (not implemented)
  final bool mKeepEnglishLetter;
  final Encoding mEncoding;
  final Language? mLanguage;

  const SequenceModel({
    required this.mCharToOrderMap,
    required this.mPrecedenceMatrix,
    required this.mFreqCharCount,
    required this.mTypicalPositiveRatio,
    required this.mKeepEnglishLetter,
    required this.mEncoding,
    required this.mLanguage,
  });

  // for using model data from the origin uchart code.
  const SequenceModel.cpp(
    List<int> charToOrderMap,
    List<int> precedenceMatrix,
    int freqCharCount,
    double mTypicalPositiveRatio,
    bool keepEnglishLetter,
    Encoding encoding,
    Language? language,
  ) : this(
        mCharToOrderMap: charToOrderMap,
        mPrecedenceMatrix: precedenceMatrix,
        mFreqCharCount: freqCharCount,
        mTypicalPositiveRatio: mTypicalPositiveRatio,
        mKeepEnglishLetter: keepEnglishLetter,
        mEncoding: encoding,
        mLanguage: language,
      );
}

class LanguageModel {
  final Language mLanguage;

  /* Table mapping codepoints to character orders. */
  final List<int> mCharOrderTable;

  /* freqCharCount x freqCharCount table of 2-char sequence's frequencies. */
  final List<int> mPrecedenceMatrix;

  /* The count of frequent characters.
   * precedenceMatrix size is the square of this count.
   * charOrderTable can be bigger as it can contain equivalent
   * characters. Yet it maps to this range of orders.
   */
  final int mFreqCharCount;

  /* Most languages have 3 or 4 characters which are used more than 40% of the
   * times. We count how many they are and what ratio they are used.
   */
  final int mVeryFreqCharCount;
  final double veryFreqRatio;
  /* Most languages will have a whole range of characters which in cumulated
   * total are barely used a few percents of the times. We count how many they
   * are and what ratio they are used.
   */
  final int mLowFreqOrder;
  final double mLowFreqRatio;

  const LanguageModel({
    required this.mLanguage,
    required this.mCharOrderTable,
    required this.mPrecedenceMatrix,
    required this.mFreqCharCount,
    required this.mVeryFreqCharCount,
    required this.veryFreqRatio,
    required this.mLowFreqOrder,
    required this.mLowFreqRatio,
  });

  // for using model data from the origin uchart code.
  const LanguageModel.cpp(
    Language language,

    List<int> charOrderTable,
    int charOrderTableSize,

    List<int> precedenceMatrix,
    int freqCharCount,
    int veryFreqCharCount,
    double veryFreqRatio,
    int lowFreqOrder,
    double lowFreqRatio,
  ) : this(
        mLanguage: language,
        mCharOrderTable: charOrderTable,
        mPrecedenceMatrix: precedenceMatrix,
        mFreqCharCount: freqCharCount,
        mVeryFreqCharCount: veryFreqCharCount,
        veryFreqRatio: veryFreqRatio,
        mLowFreqOrder: lowFreqOrder,
        mLowFreqRatio: lowFreqRatio,
      );

  static const kNull = LanguageModel(
    mLanguage: Language.chinese,
    mCharOrderTable: [],
    mPrecedenceMatrix: [],
    mFreqCharCount: 0,
    mVeryFreqCharCount: 0,
    veryFreqRatio: 0.0,
    mLowFreqOrder: 0,
    mLowFreqRatio: 0.0,
  );
}
