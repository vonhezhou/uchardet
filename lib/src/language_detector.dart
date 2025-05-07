/* -*- Mode: C; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
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
 * The Original Code is Mozilla Universal charset detector code. This
 * file was later added by Jehan in 2021 to add language detection.
 *
 * The Initial Developer of the Original Code is Netscape Communications
 * Corporation.
 * Portions created by the Initial Developer are Copyright (C) 2001 the
 * Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *          von <vonhezhou@gmail.com>: dart port
 *          Jehan <zemarmot.net> (2021)
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

import 'package:meta/meta.dart';

import './types.dart';
import 'internal_types.dart';

enum DetectLangState { detecting, found, unlikely }

@internal
class LanguageDetector {
  static const _kLangPositiveCat = 3;
  static const _kLangProbableCat = 2;
  // static const _kLangNeutralCat = 1;
  static const _kLangNegativeCat = 0;
  static const _kLangNumberOfSeqCat = 4;

  LanguageModel mModel;
  DetectLangState mState = DetectLangState.detecting;
  /* Order of last character */
  int mLastOrder = 0;

  int mTotalSeqs = 0;
  List<int> mSeqCounters = List<int>.filled(_kLangNumberOfSeqCat, 0);

  int mTotalChar = 0;

  /*int mCtrlChar;*/
  /*int mEmoticons;*/
  /*int mVariousBetween;*/
  /* Characters that fall in our sampling range */
  int mFreqChar = 0;
  /* Most common characters from our sampling range */
  int mVeryFreqChar = 0;
  /* Most rare characters from our sampling range */
  int mLowFreqChar = 0;
  int mOutChar = 0;

  LanguageDetector({required this.mModel}) {
    reset();
  }

  /* Unlike nsSingleByteCharSetProber, it is charset-unaware and only
   * looks at unicode codepoints.
   */
  DetectLangState feed(List<int> codePoints) {
    const kLangSbEnoughRelThreshold = 2048;
    const kLangPositiveShortcutThreshold = 0.95;
    const kLangNegativeShortcutThreshold = 0.05;

    int order = 0;

    for (var oneCodePoint in codePoints) {
      order = _getOrderFromCodePoint(oneCodePoint);

      mTotalChar++;

      if (order == -1) {
        if (oneCodePoint <= 0x1F ||
            oneCodePoint == 0x7F || /* C0 */
            (oneCodePoint <= 0x9F && oneCodePoint >= 0x80) || /* C1 */
            /* Separators: not strictly control characters for the Unicode
           * standard, but we'll consider as such in our purpose.
           */
            oneCodePoint == 0x2028 ||
            oneCodePoint == 0x2029 ||
            /* Tags: U+E0001 is deprecated but other are still usable as
           * emoji identifiers. Not sure how to use them.
           */
            oneCodePoint == 0xE0001 ||
            /* Interlinear annotations. */
            oneCodePoint == 0xFFF9 ||
            oneCodePoint == 0xFFFA ||
            oneCodePoint == 0xFFFB ||
            /* Bidirectional text control. */
            oneCodePoint == 0x061C ||
            oneCodePoint == 0x200E ||
            oneCodePoint == 0x200F ||
            (oneCodePoint >= 0x202A && oneCodePoint <= 0x202E) ||
            (oneCodePoint >= 0x2066 && oneCodePoint <= 0x2069) ||
            /* Control pictures. */
            (oneCodePoint >= 0x2400 && oneCodePoint <= 0x2426)) {
          /* XXX: some control characters such as variation selectors may
         * need to be considered separately (basically just as if they
         * were not here and simply skipped?). */
          //mCtrlChar++;
        }
        /* When encountering an illegal codepoint, no need
       * to continue analyzing data. It means this is not right, hence
       * that the encoding we deducted this codepoint from is wrong.
       * Unfortunately listing all illegal codePoints in Unicode might be
       * a daunting task and comparing each characters to all these
       * illegal codePoints would be a lot of additional work. Is it
       * really necessary? XXX
       */
        else if ( /* Tab, line feed and carriage returns are common enough
                * that they should be considered as commonly used characters.
                */ oneCodePoint == 0x9 ||
            oneCodePoint == 0xA ||
            oneCodePoint == 0xd ||
            (oneCodePoint >= 0x20 && oneCodePoint <= 0x40) ||
            (oneCodePoint >= 0x5B && oneCodePoint <= 0x5F) ||
            (oneCodePoint >= 0x7B && oneCodePoint <= 0x7E) ||
            (oneCodePoint >= 0xA0 && oneCodePoint <= 0xA5) ||
            (oneCodePoint >= 0xA0 && oneCodePoint <= 0xB4) ||
            (oneCodePoint >= 0xB6 && oneCodePoint <= 0xBF) ||
            oneCodePoint == 0xD7 ||
            oneCodePoint == 0xF7 ||
            /* General Punctuation */
            (oneCodePoint >= 0x2000 && oneCodePoint <= 0x206F) ||
            /* Vertical Forms */
            (oneCodePoint >= 0xFE10 && oneCodePoint <= 0xFE1F) ||
            /* CJK Symbols and Punctuation */
            (oneCodePoint >= 0x3000 && oneCodePoint <= 0x303F) ||
            /* Halfwidth and Fullwidth Forms */
            (oneCodePoint >= 0xFF00 && oneCodePoint <= 0xFFEF)) {
          /* Punctuations, various symbols, even numbers are simply
          * ignored.
          * As for halfwidth and fullwidth characters, I'm not sure what
          * to do with them, but let's go with the same logics of
          * skipping them, at least for now..
          */
          //mVariousBetween++;
        } else if ( /* Common Ctrl except the ones considered as common chars. */ (oneCodePoint >=
                    0x1F600 &&
                oneCodePoint <= 0x1F64F) ||
            oneCodePoint == 0xFE0E ||
            oneCodePoint == 0xFE0F ||
            (oneCodePoint >= 0x1F3FB && oneCodePoint <= 0x1F3FF) ||
            /* Miscellaneous Symbols */
            (oneCodePoint >= 0x2600 && oneCodePoint <= 0x26FF) ||
            /* Supplemental Symbols and Pictographs */
            (oneCodePoint >= 0x1F90C && oneCodePoint <= 0x1F93A) ||
            (oneCodePoint >= 0x1F93C && oneCodePoint <= 0x1F945) ||
            (oneCodePoint >= 0x1F947 && oneCodePoint <= 0x1F978) ||
            (oneCodePoint >= 0x1F97A && oneCodePoint <= 0x1F9CB) ||
            (oneCodePoint >= 0x1F9CD && oneCodePoint <= 0x1F9FF) ||
            /* Miscellaneous Symbols and Pictographs */
            (oneCodePoint >= 0x1F300 && oneCodePoint <= 0x1F5FF) ||
            /* Transport and Map Symbols */
            (oneCodePoint >= 0x1F680 && oneCodePoint <= 0x1F6FF) ||
            /* Dingbat */
            (oneCodePoint >= 0x2700 && oneCodePoint <= 0x27BF)) {
          //mEmoticons++;
        } else {
          /* All the rest is to be considered as non-frequent characters.
         * These are not disqualifying (we may also have a text with a bit
         * of foreign quotes in it or very unusual characters sometimes)
         * but they will drop a bit the confidence.
         */
          mOutChar++;
          order = -2;

          if (mLastOrder == -2 || mLastOrder >= 0) {
            /* Adding a non frequent sequence. */
            mTotalSeqs++;
          }
        }
      } else if (order < mModel.mFreqCharCount) {
        mFreqChar++;

        if (mLastOrder >= 0 && mLastOrder < mModel.mFreqCharCount) {
          mTotalSeqs++;
          mSeqCounters[mModel.mPrecedenceMatrix[mLastOrder *
                      mModel.mFreqCharCount +
                  order]] +=
              1;
        } else if (mLastOrder == -2) {
          /* Adding a non frequent sequence. */
          mTotalSeqs++;
        }

        if (order < mModel.mVeryFreqCharCount) mVeryFreqChar++;
        if (order > mModel.mLowFreqOrder) mLowFreqChar++;
      }
      mLastOrder = order;
    }

    if (mState == DetectLangState.detecting) {
      if (mTotalSeqs > kLangSbEnoughRelThreshold) {
        double cf = getConfidence();
        if (cf > kLangPositiveShortcutThreshold) {
          mState = DetectLangState.found;
        } else if (cf < kLangNegativeShortcutThreshold) {
          mState = DetectLangState.unlikely;
        }
      }
    }

    return mState;
  }

  void close() {}

  @mustCallSuper
  void reset() {
    mState = DetectLangState.detecting;
    mLastOrder = -1;
    mSeqCounters.fillRange(0, mSeqCounters.length, 0);
    mTotalSeqs = 0;
    mTotalChar = 0;
    //mCtrlChar  = 0;
    //mEmoticons  = 0;
    //mVariousBetween  = 0;
    mFreqChar = 0;
    mVeryFreqChar = 0;
    mLowFreqChar = 0;
    mOutChar = 0;
  }

  double getConfidence() {
    double r = 0.0;
    if (mTotalSeqs > 0) {
      /* Positive sequences will boost the confidence, probable sequence
     * only a bit but not so much, neutral sequences will stall the
     * confidence.
     * Negative sequences will negatively impact the confidence.
     */
      double positiveSeqs = mSeqCounters[_kLangPositiveCat].toDouble();
      double probableSeqs = mSeqCounters[_kLangProbableCat].toDouble();
      //double neutralSeqs  = mSeqCounters[LANG_NEUTRAL_CAT];
      double negativeSeqs = mSeqCounters[_kLangNegativeCat].toDouble();

      r = (positiveSeqs + probableSeqs / 4 - negativeSeqs * 4) / mTotalSeqs;
      /* The more characters outside the expected characters
     * (proportionnaly to the size of the text), the less confident we
     * become in the current language.
     * Note that we removed punctuations and various symbols which are
     * therefore somehow more "neutral".
     */
      r = r * (mTotalChar - mOutChar) / mTotalChar;
      r = r * mFreqChar / (mFreqChar + mOutChar);

      /* How similar are the very frequent character ratio. */
      r =
          r *
          (1.0 -
              (mVeryFreqChar / mFreqChar - mModel.veryFreqRatio).abs() / 4.0);
      /* How similar are the very rare character ratio. */
      r =
          r *
          (1.0 - (mLowFreqChar / mFreqChar - mModel.mLowFreqRatio).abs() / 4.0);

      return r;
    }
    return 0.01;
  }

  Language? getLanguage() {
    return mModel.mLanguage;
  }

  int _getOrderFromCodePoint(int codePoint) {
    int min = 0;
    int max = (mModel.mCharOrderTable.length / 2).toInt() - 1;
    int i = (max / 2).toInt();
    int c;
    while ((c = mModel.mCharOrderTable[i * 2]) != codePoint) {
      if (c > codePoint) {
        if (i == min) {
          break;
        }
        max = i - 1;
      } else {
        if (i == max) {
          break;
        }
        min = i + 1;
      }

      i = (min + (max - min) / 2).toInt();
    }

    return (c == codePoint) ? mModel.mCharOrderTable[i * 2 + 1] : -1;
  }
}
