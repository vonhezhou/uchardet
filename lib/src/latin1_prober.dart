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
import './latin1_model.dart';
import './types.dart';

class Latin1Prober extends CharSetProber {
  static const _kFreqCatNum = 4;

  int _mLastCharClass = 0;

  final _mFreqCounter = List<int>.filled(_kFreqCatNum, 0);

  Latin1Prober() {
    reset();
  }

  @override
  List<CharSetCandidate> getCandidates() {
    return [
      CharSetCandidate(
        confidence: _calcConfidence(),
        encoding: Encoding.windows1252,
        language: null,
      ),
    ];
  }

  @override
  void reset() {
    super.reset();

    _mLastCharClass = OTH;
    _mFreqCounter.fillRange(0, _kFreqCatNum, 0);
  }

  @override
  ProberState feed(Uint8List aBuf) {
    var newBuf1 = filterWithEnglishLetters(aBuf);
    var newLen1 = newBuf1.length;

    int charClass = 0;
    int freq = 0;
    for (var i = 0; i < newLen1; i++) {
      charClass = Latin1_CharToClass[newBuf1[i]];
      freq = Latin1ClassModel[_mLastCharClass * CLASS_NUM + charClass];
      if (freq == 0) {
        mState = ProberState.notMe;
        break;
      }
      _mFreqCounter[freq]++;
      _mLastCharClass = charClass;
    }

    return mState;
  }

  double _calcConfidence() {
    if (mState == ProberState.notMe) {
      return 0.01;
    }

    double confidence;
    int total = 0;
    for (int i = 0; i < _kFreqCatNum; i++) {
      total += _mFreqCounter[i];
    }

    if (total == 0) {
      confidence = 0.0;
    } else {
      confidence = _mFreqCounter[3] * 1.0 / total;
      confidence -= _mFreqCounter[1] * 20.0 / total;
    }

    if (confidence < 0.0) {
      confidence = 0.0;
    }

    // lower the confidence of latin1 so that other more accurate detector
    // can take priority.
    confidence *= 0.50;

    return confidence;
  }
}
