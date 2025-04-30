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

import 'package:uchardet/src/types.dart';

import './charset_prober.dart';

class Big5Prober extends CharSetProber {
  bool _mIsFirstByte = false;
  int _mFirstByte = 0;
  int _mSymbolCount = 0;
  int _mAsciiLetterCount = 0;
  int _mGraphCharCount = 0;
  int _mFreqCharCount = 0;
  int _mReservedCount = 0;
  int _mRareCharCount = 0;

  Big5Prober() {
    reset();
  }

  @override
  List<CharSetCandidate> getCandidates() {
    return [
      CharSetCandidate(
        confidence: _calcConfidence(),
        encoding: Encoding.big5,
        language: Language.chinese,
      ),
    ];
  }

  @override
  void reset() {
    _mIsFirstByte = true;
    /* Actually symbol and numbers. */
    _mSymbolCount = 0;
    _mAsciiLetterCount = 0;
    _mGraphCharCount = 0;
    _mFreqCharCount = 0;
    _mReservedCount = 0;
    _mRareCharCount = 0;

    super.reset();
  }

  @override
  ProberState feed(Uint8List aBuf) {
    if (mState == ProberState.notMe) {
      return mState;
    }

    for (var c in aBuf) {
      if (_mIsFirstByte) {
        /* Wikipedia says: "Big5 does not specify a single-byte component;
       * however, ASCII (or an extension) is used in practice."
       */
        if ((c >= 0x20 && c <= 0x40) ||
            (c >= 0x5C && c <= 0x60) ||
            (c >= 0x7C && c <= 0x7E)) {
          /* Symbols and numbers. */
          _mSymbolCount++;
        } else if ((c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A)) {
          _mAsciiLetterCount++;
        } else if (c >= 0x81 && c <= 0xfe) {
          /* Actual Big5 character in 2 bytes. */
          _mIsFirstByte = false;
          _mFirstByte = c;
        } else {
          /* Invalid. */
          mState = ProberState.notMe;
          return mState;
        }
      } else {
        if ( /* Reserved for user-defined characters */ (_mFirstByte == 0x81 &&
                c >= 0x40) ||
            (_mFirstByte > 0x81 && _mFirstByte < 0xA0) ||
            (_mFirstByte == 0xA0 && c < 0xFE) ||
            /* Reserved, not for user-defined characters */
            (_mFirstByte == 0xA3 && (c >= 0xC0 || c <= 0xFE)) ||
            /* Reserved, not for user-defined characters */
            (_mFirstByte == 0xC6 && c >= 0xA1) ||
            (_mFirstByte > 0xC6 && _mFirstByte < 0xC8) ||
            (_mFirstByte == 0xC8 && c < 0xFE) ||
            /* Reserved, not for user-defined characters */
            (_mFirstByte == 0xF9 && c >= 0xD6) ||
            (_mFirstByte > 0xF9 && _mFirstByte < 0xFE) ||
            (_mFirstByte == 0xFE && c < 0xFE)) {
          _mReservedCount++;
        } else if ((_mFirstByte == 0xA1 && c >= 0x40) ||
            (_mFirstByte > 0xA1 && _mFirstByte < 0xA3) ||
            (_mFirstByte == 0xA3 && c < 0xBF)) {
          _mGraphCharCount++;
        } else if ((_mFirstByte == 0xA4 && c >= 0x40) ||
            (_mFirstByte > 0xA4 && _mFirstByte < 0xC6) ||
            (_mFirstByte == 0xC6 && c < 0x7E)) {
          _mFreqCharCount++;
        } else if ((_mFirstByte == 0xC9 && c >= 0x40) ||
            (_mFirstByte > 0xC9 && _mFirstByte < 0xF9) ||
            (_mFirstByte == 0xF9 && c < 0xD5)) {
          _mRareCharCount++;
        } else {
          /* Invalid. */
          mState = ProberState.notMe;
          return mState;
        }
        _mIsFirstByte = true;
      }
    }

    return mState;
  }

  double _calcConfidence() {
    int letterCount = _mAsciiLetterCount + _mFreqCharCount + _mRareCharCount;
    int charCount =
        letterCount + _mSymbolCount + _mGraphCharCount + _mReservedCount;

    var confidence =
        (_mFreqCharCount +
            0.5 * _mRareCharCount -
            _mAsciiLetterCount -
            2.0 * _mReservedCount) /
        charCount;
    return confidence;
  }
}
