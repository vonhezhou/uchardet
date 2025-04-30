/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
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
 * The Original Code is Mozilla Communicator client code.
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

import 'package:meta/meta.dart';

import './char_distribution.dart';
import './jp_char_context.dart';

abstract class JapaneseContextAnalysis {
  static const _kNumOfCategory = 6;

  static const _kEnoughRelThreshold = 100;
  static const _kMaxRelThreshold = 1000;

  JapaneseContextAnalysis() {
    reset(false);
  }

  void reset(bool aIsPreferredLanguage) {
    _mTotalRel = 0;
    _mRelSample.fillRange(0, _mRelSample.length, 0);
    _mLastCharOrder = -1;
    _mDone = false;
    _mDataThreshold =
        aIsPreferredLanguage
            ? 0
            : CharDistributionAnalysis.kMinimumDataThreshold;
  }

  double getConfidence() {
    const kDontKnow = -1.0;
    //This is just one way to calculate confidence. It works well for me.
    if (_mTotalRel > _mDataThreshold) {
      return ((_mTotalRel - _mRelSample[0])) / _mTotalRel;
    } else {
      return kDontKnow;
    }
  }

  void feedOneChar(Uint8List aStr) {
    int order;

    //if we received enough data, stop here
    if (_mTotalRel > _kMaxRelThreshold) _mDone = true;
    if (_mDone) return;

    //Only 2-bytes characters are of our interest
    order = (aStr.length == 2) ? getOrder(aStr) : -1;
    if (order != -1 && _mLastCharOrder != -1) {
      _mTotalRel++;
      //count this sequence to its category counter
      _mRelSample[jp2CharContext[_mLastCharOrder][order]]++;
    }
    _mLastCharOrder = order;
  }

  bool gotEnoughData() {
    return _mTotalRel > _kEnoughRelThreshold;
  }

  @protected
  int getOrder(Uint8List str);

  //category counters, each integer counts sequences in its category
  @protected
  // NUM_OF_CATEGORY
  final List<int> _mRelSample = List.filled(_kNumOfCategory, 0);

  // total sequence received
  @protected
  int _mTotalRel = 0;

  // Number of sequences needed to trigger detection
  @protected
  int _mDataThreshold = 0;

  //The order of previous char
  @protected
  int _mLastCharOrder = 0;

  //If this flag is set to true, detection is done and conclusion has been made
  @protected
  bool _mDone = false;
}

class SJISContextAnalysis extends JapaneseContextAnalysis {
  @override
  int getOrder(Uint8List str) {
    //We only interested in Hiragana, so first byte is '\202' which is 0x82
    if (str.length >= 2 && str[0] == 0x82 && str[1] >= 0x9f && str[1] <= 0xf1) {
      return str[1] - 0x9f;
    }
    return -1;
  }
}

class EUCJPContextAnalysis extends JapaneseContextAnalysis {
  @override
  int getOrder(Uint8List str) {
    //We only interested in Hiragana, so first byte is '\244' which is A4
    if (str.length >= 2 && str[0] == 0xA4 && str[1] >= 0xa1 && str[1] <= 0xf3) {
      return str[1] - 0xa1;
    }
    return -1;
  }
}
