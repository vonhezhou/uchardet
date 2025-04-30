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
 * The Original Code is mozilla.org code.
 *
 * The Initial Developer of the Original Code is
 * Netscape Communications Corporation.
 * Portions created by the Initial Developer are Copyright (C) 1998
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *          von <vonhezhou@gmail.com>: dart port
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

import 'package:uchardet/src/mbcs_sm_model.dart';

import './char_distribution.dart';
import './charset_prober.dart';
import './coding_state_machine.dart';
import './types.dart';

// for S-JIS encoding, obeserve characteristic:
// 1, kana character (or hankaku?) often have hight frequency of appereance
// 2, kana character often exist in group
// 3, certain combination of kana is never used in japanese language

// We use GB18030 to replace GB2312, because 18030 is a superset.

class GB18030Prober extends CharSetProber {
  final CodingStateMachine _mCodingSM;

  //GB2312ContextAnalysis mContextAnalyser;
  final _mDistributionAnalyser = GB2312DistributionAnalysis();

  final _mLastChar = Uint8List(2);

  final bool _mIsPreferredLanguage;

  GB18030Prober(bool aIsPreferredLanguage)
    : _mIsPreferredLanguage = aIsPreferredLanguage,
      _mCodingSM = CodingStateMachine(
        model: MBCSStateMachineModels.kGB18030Model,
      ) {
    reset();
  }

  @override
  List<CharSetCandidate> getCandidates() {
    return [
      CharSetCandidate(
        confidence: _calcConfidence(),
        encoding: Encoding.gb18030,
        language: Language.chinese,
      ),
    ];
  }

  @override
  void reset() {
    super.reset();

    _mCodingSM.reset();
    _mDistributionAnalyser.reset(_mIsPreferredLanguage);
    //mContextAnalyser.Reset();
  }

  @override
  ProberState feed(Uint8List aBuf) {
    var codingState = 0;
    for (var i = 0; i < aBuf.length; i++) {
      codingState = _mCodingSM.nextState(aBuf[i]);
      if (codingState == eItsMe) {
        mState = ProberState.foundIt;
        break;
      }

      if (codingState == eStart) {
        var charLen = _mCodingSM.currentCharLen;

        if (i == 0) {
          _mLastChar[1] = aBuf[0];
          _mDistributionAnalyser.feedOneChar(_mLastChar.sublist(0, charLen));
        } else {
          _mDistributionAnalyser.feedOneChar(
            aBuf.sublist(i - 1, i - 1 + charLen),
          );
        }
      }
    }

    _mLastChar[0] = aBuf.last;

    if (mState == ProberState.detecting &&
        _mDistributionAnalyser.gotEnoughData() &&
        _calcConfidence() > CharSetProber.kShortcutThreshold) {
      mState = ProberState.foundIt;
    }
    //    else
    //      mDistributionAnalyser.HandleData(aBuf, aLen);

    return mState;
  }

  double _calcConfidence() {
    double distribCf = _mDistributionAnalyser.getConfidence();

    return distribCf;
  }
}
