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

import 'package:uchardet/src/internal_types.dart';
import 'package:uchardet/src/types.dart';

import './language_detector.dart';

class CJKDetector extends LanguageDetector {
  /* Chinese characters (Kanji in Japanese) */
  int _mHanziChar = 0;
  /* Korean alphabet and syllabaries */
  int _mHangulChar = 0;
  /* Hiragana and Katakana (Japanese) */
  int _mKanaChar = 0;

  Language? _mLanguage;
  double _mConfidence = 0;

  CJKDetector() : super(mModel: LanguageModel.kNull) {
    reset();
  }

  @override
  void reset() {
    super.reset();

    _mHangulChar = 0;
    _mKanaChar = 0;
    _mHanziChar = 0;
  }

  @override
  DetectLangState feed(List<int> codePoints) {
    const kCJKEnoughCharThreshold = 4096;
    const kCJKPositiveShortcutThreshold = 0.95;
    const kCJKNegativeShortcutThreshold = 0.05;

    for (var oneCodePoint in codePoints) {
      mTotalChar++;

      if ((oneCodePoint >= 0xAC00 && oneCodePoint <= 0xD7A3) ||
          (oneCodePoint >= 0x1100 && oneCodePoint <= 0x11FF) ||
          (oneCodePoint >= 0x3130 && oneCodePoint <= 0x318F) ||
          (oneCodePoint >= 0xA960 && oneCodePoint <= 0xA97F) ||
          (oneCodePoint >= 0xD7B0 && oneCodePoint <= 0xD7FF)) {
        _mHangulChar++;
      } else if ((oneCodePoint >= 0x3041 && oneCodePoint <= 0x309F) ||
          (oneCodePoint >= 0x30A0 && oneCodePoint <= 0x30FF)) {
        _mKanaChar++;
      } else if (oneCodePoint >= 0x4E00 && oneCodePoint <= 0x9FBF) {
        _mHanziChar++;
      } else if (oneCodePoint <= 0x1F ||
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
      }
    }

    if (mState == DetectLangState.detecting) {
      if (mTotalChar > kCJKEnoughCharThreshold) {
        _computeConfidence();
        if (_mConfidence > kCJKPositiveShortcutThreshold) {
          mState = DetectLangState.found;
        } else if (_mConfidence < kCJKNegativeShortcutThreshold) {
          mState = DetectLangState.unlikely;
        }
      }
    }

    return mState;
  }

  @override
  double getConfidence() {
    _computeConfidence();

    return _mConfidence;
  }

  @override
  Language? getLanguage() {
    _computeConfidence();

    return _mLanguage;
  }

  void _computeConfidence() {
    double confKo = 0.01;
    double confJa = 0.01;
    double confZh = 0.01;
    double allChars =
        (mOutChar + _mHanziChar + _mHangulChar + _mKanaChar).toDouble();
    double hangulChars = _mHangulChar.toDouble();
    double hanziChars = _mHanziChar.toDouble();
    double kanaChars = _mKanaChar.toDouble();

    _mLanguage = null;
    _mConfidence = 0.01;

    if (mTotalChar > 0) {
      confKo = hangulChars / allChars;
      _mLanguage = Language.korean;
      _mConfidence = confKo;

      confZh = hanziChars / allChars;
      if (confZh > confKo) {
        _mLanguage = Language.chinese;
        _mConfidence = confZh;
      }

      /* Japanese still uses a lot of Chinese characters, so I think this
     * very naive confidence computation will need to be revised soon.
     * We should probably compute statistics of hanzi / (hanzi + kana)
     * characters and use this as a weight modifier.
     */
      confJa = (kanaChars + hanziChars / 2.0) / allChars;
      if (confJa > _mConfidence) {
        _mLanguage = Language.japanese;
        _mConfidence = confJa;
      }
    }
  }
}
