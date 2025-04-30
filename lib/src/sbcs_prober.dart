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
 * The Original Code is Mozilla Universal charset detector code.
 *
 * The Initial Developer of the Original Code is
 * Netscape Communications Corporation.
 * Portions created by the Initial Developer are Copyright (C) 2001
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *          von <vonhezhou@gmail.com>: dart port
 *          Shy Shalom <shooshX@gmail.com>
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

import 'dart:typed_data';

import './charset_prober.dart';
import './types.dart';
import 'internal_types.dart';

class SingleByteCharSetProber extends CharSetProber {
  static const _kNumberOfSeqCat = 4;
  static const _kPositiveCat = (_kNumberOfSeqCat - 1);
  static const _kProbableCat = (_kNumberOfSeqCat - 2);
  // static const _kNeutralCat = (_kNumberOfSeqCat - 3);
  static const _kNegativeCat = 0;

  SequenceModel model;

  // true if we need to reverse every pair in the model lookup
  final bool reversed;

  //char order of last character
  // unsigned char mLastOrder;
  int mLastOrder = 0;

  int mTotalSeqs = 0;
  final List<int> mSeqCounters = List.filled(_kNumberOfSeqCat, 0);

  int mTotalChar = 0;
  int mCtrlChar = 0;
  //characters that fall in our sampling range
  int mFreqChar = 0;
  int mOutChar = 0;

  SingleByteCharSetProber({required this.model, this.reversed = false}) {
    reset();
  }

  @override
  ProberState feed(Uint8List aBuf) {
    const kSymbolCatOrder = 250;

    int order = 0;
    for (var codeUnit in aBuf) {
      order = model.mCharToOrderMap[codeUnit];

      mTotalChar++;
      if (order == ILL) {
        /* When encountering an illegal codepoint, no need
       * to continue analyzing data. */
        mState = ProberState.notMe;
        break;
      } else if (order == CTR) {
        mCtrlChar++;
      } else if (order < model.mFreqCharCount) {
        mFreqChar++;

        if (mLastOrder < model.mFreqCharCount) {
          mTotalSeqs++;
          var index = 0;
          if (!reversed) {
            index = mLastOrder * model.mFreqCharCount + order;
          } else {
            // reverse the order of the letters in the lookup
            index = order * model.mFreqCharCount + mLastOrder;
          }
          mSeqCounters[model.mPrecedenceMatrix[index]] += 1;
        } else if (mLastOrder < kSymbolCatOrder) {
          mSeqCounters[_kNegativeCat]++;
          mTotalSeqs++;
        }
      } else if (order < kSymbolCatOrder) {
        mOutChar++;

        if (mLastOrder < kSymbolCatOrder) {
          mTotalSeqs++;
          mSeqCounters[_kNegativeCat]++;
        }
      }
      mLastOrder = order;
    }

    if (mState == ProberState.detecting) {
      const kSingleByteEnoughRelThreshold = 1024;
      const kPositiveShortcutThreshold = 0.95;
      const kNegativeShortcutThreshold = 0.05;
      if (mTotalSeqs > kSingleByteEnoughRelThreshold) {
        double cf = _calcConfidence();
        if (cf > kPositiveShortcutThreshold) {
          mState = ProberState.foundIt;
        } else if (cf < kNegativeShortcutThreshold) {
          mState = ProberState.notMe;
        }
      }
    }
    return mState;
  }

  @override
  void reset() {
    mState = ProberState.detecting;
    mLastOrder = 255;
    mSeqCounters.fillRange(0, _kNumberOfSeqCat, 0);
    mTotalSeqs = 0;
    mTotalChar = 0;
    mCtrlChar = 0;
    mFreqChar = 0;
    mOutChar = 0;

    super.reset();
  }

  @override
  List<CharSetCandidate> getCandidates() {
    return [
      CharSetCandidate(
        encoding: model.mEncoding,
        language: model.mLanguage,
        confidence: _calcConfidence(),
      ),
    ];
  }

  double getConfidence() {
    return _calcConfidence();
  }

  double _calcConfidence() {
    double r = 0.0;

    if (mTotalSeqs > 0) {
      double positiveSeqs = mSeqCounters[_kPositiveCat].toDouble();
      double probableSeqs = mSeqCounters[_kProbableCat].toDouble();
      double negativeSeqs = mSeqCounters[_kNegativeCat].toDouble();

      r =
          (positiveSeqs + probableSeqs / 4 - negativeSeqs * 4) /
          mTotalSeqs /
          model.mTypicalPositiveRatio;
      r = r * (mTotalChar - mOutChar - mCtrlChar) / mTotalChar;
      r = r * mFreqChar / mTotalChar;

      return r;
    }
    return 0.01;
  }
}
