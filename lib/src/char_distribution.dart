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

import 'lang_freq/euckr_freq.dart';
import 'lang_freq/euctw_freq.dart';
import 'lang_freq/gb2312_freq.dart';
import 'lang_freq/jis_freq.dart';
import 'lang_freq/johab_freq.dart';

abstract class CharDistributionAnalysis {
  static const kMinimumDataThreshold = 4;

  CharDistributionAnalysis() {
    reset(false);
  }

  // Feed a character with known length
  void feedOneChar(Uint8List aStr) {
    int order;

    //we only care about 2-bytes character in our distribution analysis
    order = (aStr.length == 2) ? getOrder(aStr) : -1;

    if (order >= 0) {
      mTotalChars++;
      //order is valid
      if (order < mCharToFreqOrder.length) {
        if (512 > mCharToFreqOrder[order]) {
          mFreqChars++;
        }
      }
    }
  }

  /// return confidence base on existing data
  double getConfidence() {
    //if we didn't receive any character in our consideration range, or the
    // number of frequent characters is below the minimum threshold, return
    // negative answer
    const kSureNo = 0.01;
    const kSureYes = 0.7;
    if (mTotalChars <= 0 || mFreqChars <= mDataThreshold) {
      return kSureNo;
    }

    if (mTotalChars != mFreqChars) {
      double r =
          mFreqChars / ((mTotalChars - mFreqChars) * mTypicalDistributionRatio);

      if (r < kSureYes) {
        return r;
      }
    }
    //normalize confidence, (we don't want to be 100% sure)
    return kSureYes;
  }

  /// Reset analyser, clear any state
  void reset(bool aIsPreferredLanguage) {
    mDone = false;
    mTotalChars = 0;
    mFreqChars = 0;
    mDataThreshold = aIsPreferredLanguage ? 0 : kMinimumDataThreshold;
  }

  /// It is not necessary to receive all data to draw conclusion. For charset detection,
  /// certain amount of data is enough
  bool gotEnoughData() {
    const kEnoughDataThreshold = 1024;
    return mTotalChars > kEnoughDataThreshold;
  }

  /// we do not handle character base on its original encoding string, but
  /// convert this encoding string to a number, here called order.
  /// This allow multiple encoding of a language to share one frequency table
  @protected
  int getOrder(Uint8List str) {
    return -1;
  }

  /// If this flag is set to true, detection is done and conclusion has been made
  @protected
  bool mDone = false;

  /// The number of characters whose frequency order is less than 512
  @protected
  int mFreqChars = 0;

  /// Total character encounted.
  @protected
  int mTotalChars = 0;

  /// Number of hi-byte characters needed to trigger detection
  @protected
  int mDataThreshold = 0;

  /// Mapping table to get frequency order from char order (get from GetOrder())
  @protected
  List<int> mCharToFreqOrder = [];

  /// This is a constant value varies from language to language, it is used in
  /// calculating confidence. See my paper for further detail.
  @protected
  double mTypicalDistributionRatio = 0.0;
}

class EUCTWDistributionAnalysis extends CharDistributionAnalysis {
  // return confidence base on received data
  EUCTWDistributionAnalysis() {
    mCharToFreqOrder = EUCTWCharToFreqOrder;
    mTypicalDistributionRatio = EUCTW_TYPICAL_DISTRIBUTION_RATIO;
  }

  //for EUC-TW encoding, we are interested
  //  first  byte range: 0xc4 -- 0xfe
  //  second byte range: 0xa1 -- 0xfe
  //no validation needed here. State machine has done that
  @override
  int getOrder(Uint8List str) {
    if (str.length >= 2 && str[0] >= 0xc4) {
      return 94 * (str[0] - 0xc4) + str[1] - 0xa1;
    } else {
      return -1;
    }
  }
}

class EUCKRDistributionAnalysis extends CharDistributionAnalysis {
  EUCKRDistributionAnalysis() {
    mCharToFreqOrder = EUCKRCharToFreqOrder;
    mTypicalDistributionRatio = EUCKR_TYPICAL_DISTRIBUTION_RATIO;
  }

  /// for euc-KR encoding, we are interested
  ///   first  byte range: 0xb0 -- 0xfe
  ///   second byte range: 0xa1 -- 0xfe
  /// no validation needed here. State machine has done that
  @override
  int getOrder(Uint8List str) {
    if (str.length >= 2 && str[0] >= 0xb0) {
      return 94 * (str[0] - 0xb0) + str[1] - 0xa1;
    } else {
      return -1;
    }
  }
}

class JohabDistributionAnalysis extends CharDistributionAnalysis {
  JohabDistributionAnalysis() {
    mCharToFreqOrder = EUCKRCharToFreqOrder;
    mTypicalDistributionRatio = EUCKR_TYPICAL_DISTRIBUTION_RATIO;
  }

  /// for Johab encoding, we are interested
  ///   first  byte range: 0x88 -- 0xd3
  ///   second byte range: 0x41 -- 0xfe
  /// no validation needed here. State machine has done that
  @override
  int getOrder(Uint8List str) {
    if (str.length >= 2) {
      var c = str[0];
      if ((0x88 <= c) && (c <= 0xd3)) {
        return _johabToEUCKR(c, str[1]);
      }
    }
    return -1;
  }

  int _johabToEUCKR(int c1, int c2) {
    int a = JohabCho[(c1 >> 2) & 0x1f];
    int b = JohabJung[((c1 << 3) | (c2 >> 5)) & 0x1f];
    int c = JohabJong[c2 & 0x1f];

    if (a == 0xff || b == 0xff || c == 0xff) {
      return -1;
    }

    return JohabToEUCKROrder[a * 21 * 28 + b * 28 + c];
  }
}

class GB2312DistributionAnalysis extends CharDistributionAnalysis {
  GB2312DistributionAnalysis() {
    mCharToFreqOrder = GB2312CharToFreqOrder;
    mTypicalDistributionRatio = GB2312_TYPICAL_DISTRIBUTION_RATIO;
  }

  /// for GB2312 encoding, we are interested
  ///   first  byte range: 0xb0 -- 0xfe
  ///   second byte range: 0xa1 -- 0xfe
  /// no validation needed here. State machine has done that
  @override
  int getOrder(Uint8List str) {
    if (str.length >= 2 && str[0] >= 0xb0 && str[1] >= 0xa1) {
      return 94 * (str[0] - 0xb0) + str[1] - 0xa1;
    } else {
      return -1;
    }
  }
}

class Big5DistributionAnalysis extends CharDistributionAnalysis {
  Big5DistributionAnalysis();

  /// for big5 encoding, we are interested
  ///  first  byte range: 0xa4 -- 0xfe
  ///  second byte range: 0x40 -- 0x7e , 0xa1 -- 0xfe
  /// no validation needed here. State machine has done that
  @override
  int getOrder(Uint8List str) {
    if (str.length >= 2 && str[0] >= 0xa4) {
      if (str[1] >= 0xa1) {
        return 157 * (str[0] - 0xa4) + str[1] - 0xa1 + 63;
      } else {
        return 157 * (str[0] - 0xa4) + str[1] - 0x40;
      }
    } else {
      return -1;
    }
  }
}

class SJISDistributionAnalysis extends CharDistributionAnalysis {
  SJISDistributionAnalysis() {
    mCharToFreqOrder = JISCharToFreqOrder;
    mTypicalDistributionRatio = JIS_TYPICAL_DISTRIBUTION_RATIO;
  }

  // for sjis encoding, we are interested
  //   first  byte range: 0x81 -- 0x9f , 0xe0 -- 0xfe
  //   second byte range: 0x40 -- 0x7e,  0x81 -- oxfe
  // no validation needed here. State machine has done that
  @override
  int getOrder(Uint8List str) {
    if (str.length < 2) {
      return -1;
    }

    int order = -1;
    if (str[0] >= 0x81 && str[0] <= 0x9f) {
      order = 188 * (str[0] - 0x81);
    } else if (str[0] >= 0xe0 && str[0] <= 0xef) {
      order = 188 * (str[0] - 0xe0 + 31);
    } else {
      return -1;
    }
    order += str[1] - 0x40;
    if (str[1] > 0x7f) {
      order--;
    }
    return order;
  }
}

class EUCJPDistributionAnalysis extends CharDistributionAnalysis {
  EUCJPDistributionAnalysis() {
    mCharToFreqOrder = JISCharToFreqOrder;
    mTypicalDistributionRatio = JIS_TYPICAL_DISTRIBUTION_RATIO;
  }

  // for euc-JP encoding, we are interested
  //   first  byte range: 0xa0 -- 0xfe
  //   second byte range: 0xa1 -- 0xfe
  // no validation needed here. State machine has done that
  @override
  int getOrder(Uint8List str) {
    if (str.length >= 2 && str[0] >= 0xa0) {
      return 94 * (str[0] - 0xa1) + str[1] - 0xa1;
    } else {
      return -1;
    }
  }
}
