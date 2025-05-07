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

//#define DEBUG_chardet // Uncomment this for debug dump.

import 'dart:typed_data';

import 'package:meta/meta.dart';

import './base/ascii_utils.dart';
import './types.dart';

enum ProberState {
  detecting, // we are still detecting, no sure answer yet, but caller can ask for confidence.
  foundIt, // That's a positive answer
  notMe, // Negative answer
}

abstract class CharSetProber {
  static const kShortcutThreshold = 0.95;

  @protected
  @internal
  ProberState mState = ProberState.detecting;

  @internal
  bool mActive = true;

  // sub class, e.g. hebrew prober, might override this
  ProberState getState() => mState;

  ProberState feed(Uint8List buf);
  void close() {}

  @mustBeOverridden
  List<CharSetCandidate> getCandidates();

  bool decodeToUnicode() => false;

  @mustCallSuper
  void reset() {
    mState = ProberState.detecting;
    mActive = true;
  }

  // Helper functions used in the Latin1 and Group probers.
  // both functions Allocate a new buffer for newBuf. This buffer should be
  // freed by the caller using PR_FREEIF.
  // Both functions return false in case of memory allocation failure.
  // This filter applies to all scripts which do not use English characters
  @useResult
  Uint8List filterWithoutEnglishLetters(Uint8List aBuf) {
    var newBuf = <int>[];

    bool meetMSB = false;
    var ii = 0;
    var prevPtr = 0;
    for (ii = 0; ii < aBuf.length; ++ii) {
      var codeUnit = aBuf[ii];
      if (codeUnit > 0x7F) {
        meetMSB = true;
      } else if (!isAsciiEnglishLetter(codeUnit)) {
        // current char is a symbol, most likely a punctuation. we treat it as segment delimiter
        if (meetMSB && ii > prevPtr) {
          // this segment contains more than single symbol, and it has upper ASCII, we need to keep it
          newBuf.addAll(aBuf.sublist(prevPtr, ii));
          newBuf.add(kAsciiWhiteSpace);
          prevPtr = ii + 1;
          meetMSB = false;
        } else {
          // ignore current segment. (either because it is just a symbol or just an English word)
          prevPtr = ii + 1;
        }
      }
    }

    if (meetMSB && ii > prevPtr) {
      newBuf.addAll(aBuf.sublist(prevPtr, ii));
    }

    return Uint8List.fromList(newBuf);
  }

  //This filter applies to all scripts which contain both English characters and upper ASCII characters.
  @useResult
  Uint8List filterWithEnglishLetters(Uint8List aBuf) {
    var newBuf = <int>[];

    bool isInTag = false;

    //do filtering to reduce load to probers
    int prevPtr = 0;
    int curPtr = 0;
    for (curPtr = prevPtr = 0; curPtr < aBuf.length; ++curPtr) {
      var char = aBuf[curPtr];
      if (char == kAsciiRightAngleBracket) {
        isInTag = false;
      } else if (char == kAsciiLeftAngleBracket) {
        isInTag = true;
      }

      if (!(isNonAsciiHighByte(char)) && !isAsciiEnglishLetter(char)) {
        if (curPtr > prevPtr && !isInTag) {
          // Current segment contains more than just a symbol
          // and it is not inside a tag, keep it.
          newBuf.addAll(aBuf.sublist(prevPtr, curPtr));
          newBuf.add(kAsciiWhiteSpace);
          prevPtr = curPtr + 1;
        } else {
          prevPtr = curPtr + 1;
        }
      }
    }

    // If the current segment contains more than just a symbol
    // and it is not inside a tag then keep it.
    if (!isInTag && prevPtr < curPtr) {
      newBuf.addAll(aBuf.sublist(prevPtr, curPtr));
    }

    return Uint8List.fromList(newBuf);
  }
}
