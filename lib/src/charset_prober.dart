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

  List<CharSetCandidate> getCandidates();

  /// 内部比较不应为了读取一个数值而创建候选列表。
  double get confidence => getCandidates().firstOrNull?.confidence ?? 0.0;

  bool decodeToUnicode() => false;

  @mustCallSuper
  void reset() {
    mState = ProberState.detecting;
    mActive = true;
  }

  static final _emptyBytes = Uint8List(0);
  Uint8List _filterBuffer = _emptyBytes;

  Uint8List _prepareFilterBuffer(int length) {
    // 保留常用大小的缓冲；一次性大输入不应永久撑大实例占用。
    if (length > 65536) return Uint8List(length);
    if (_filterBuffer.length < length) {
      var capacity = _filterBuffer.isEmpty ? 256 : _filterBuffer.length;
      while (capacity < length) {
        capacity *= 2;
      }
      _filterBuffer = Uint8List(capacity);
    }
    return _filterBuffer;
  }

  /// 返回的内部视图仅在下次过滤前有效，prober 必须同步消费。
  @useResult
  Uint8List filterWithoutEnglishLetters(Uint8List bytes) {
    final output = _prepareFilterBuffer(bytes.length);
    var hasHighByte = false;
    var start = 0;
    var written = 0;
    for (var i = 0; i < bytes.length; i++) {
      final byte = bytes[i];
      if (byte > 0x7f) {
        hasHighByte = true;
      } else if (!isAsciiEnglishLetter(byte)) {
        if (hasHighByte && i > start) {
          output.setRange(written, written + i - start, bytes, start);
          written += i - start;
          output[written++] = kAsciiWhiteSpace;
          hasHighByte = false;
        }
        start = i + 1;
      }
    }
    if (hasHighByte && bytes.length > start) {
      output.setRange(written, written + bytes.length - start, bytes, start);
      written += bytes.length - start;
    }
    return written == 0
        ? _emptyBytes
        : Uint8List.sublistView(output, 0, written);
  }

  /// 与单字节过滤共用暂存区，保留上游 HTML 标签边界的启发式规则。
  @useResult
  Uint8List filterWithEnglishLetters(Uint8List bytes) {
    final output = _prepareFilterBuffer(bytes.length);
    var isInTag = false;
    var start = 0;
    var written = 0;
    for (var i = 0; i < bytes.length; i++) {
      final byte = bytes[i];
      if (byte == kAsciiRightAngleBracket) {
        isInTag = false;
      } else if (byte == kAsciiLeftAngleBracket) {
        isInTag = true;
      }
      if (!isNonAsciiHighByte(byte) && !isAsciiEnglishLetter(byte)) {
        if (i > start && !isInTag) {
          output.setRange(written, written + i - start, bytes, start);
          written += i - start;
          output[written++] = kAsciiWhiteSpace;
        }
        start = i + 1;
      }
    }
    if (!isInTag && start < bytes.length) {
      output.setRange(written, written + bytes.length - start, bytes, start);
      written += bytes.length - start;
    }
    return written == 0
        ? _emptyBytes
        : Uint8List.sublistView(output, 0, written);
  }
}
