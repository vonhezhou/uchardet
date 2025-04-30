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


import './coding_state_machine.dart';
import 'types.dart';

class MBCSStateMachineModels {
  static const kEUCJPModel = StateMachineModel(
    classTable: _kEUCJPClassTable,
    stateTable: _kEUCJPStateTable,
    charLenTable: _kEUCJPCharLenTable,
    classFactor: 6,
    name: "EUC-JP",
    encoding: Encoding.eucJP,
    language: Language.japanese,
  );

  static const kEUCKRModel = StateMachineModel(
    classTable: _kEUCKRClassTable,
    stateTable: _kEUCKRStateTable,
    charLenTable: _kEUCKRCharLenTable,
    classFactor: 4,
    name: "EUC-KR",
    encoding: Encoding.eucKR,
    language: Language.korean,
  );

  static const kJohabModel = StateMachineModel(
    classTable: _kJohabClassTable,
    stateTable: _kJohabStateTable,
    charLenTable: _kJohabCharLenTable,
    classFactor: 10,
    name: "Johab",
    encoding: Encoding.johab,
    language: Language.korean,
  );

  static const kEUCTWModel = StateMachineModel(
    classTable: _kEUCTWClassTable,
    stateTable: _kEUCTWStateTable,
    charLenTable: _kEUCTWCharLenTable,
    classFactor: 7,
    name: "EUC-TW",
    encoding: Encoding.eucTW,
    language: Language.chinese,
  );

  static const kShiftJISModel = StateMachineModel(
    classTable: _kShiftJisClassTable,
    stateTable: _kShiftJisStateTable,
    charLenTable: _kShiftJisCharLenTable,
    classFactor: 6,
    name: "SHIFT_JIS",
    encoding: Encoding.shiftJIS,
    language: Language.japanese,
  );

  static const kGB18030Model = StateMachineModel(
    classTable: _kGB18030ClassTable,
    stateTable: _kGB18030StateTable,
    charLenTable: _kGB18030CharLenTable,
    classFactor: 7,
    name: "GB18030",
    encoding: Encoding.gb18030,
    language: Language.chinese,
  );

  static const kUTF8Model = StateMachineModel(
    classTable: _kUTF8ClassTable,
    stateTable: _kUTF8StateTable,
    charLenTable: _kUTF8CharLenTable,
    classFactor: 16,
    name: "UTF-8",
    encoding: Encoding.utf8,
    language: null,
  );
}

// dart format off
const _kEUCJPClassTable = [
  // PCK4BITS(5,4,4,4,4,4,4,4),  // 00 - 07
  4, 4, 4, 4, 4, 4, 4, 4, // 00 - 07
  4, 4, 4, 4, 4, 4, 5, 5, // 08 - 0f
  4, 4, 4, 4, 4, 4, 4, 4, // 10 - 17
  4, 4, 4, 5, 4, 4, 4, 4, // 18 - 1f
  4, 4, 4, 4, 4, 4, 4, 4, // 20 - 27
  4, 4, 4, 4, 4, 4, 4, 4, // 28 - 2f
  4, 4, 4, 4, 4, 4, 4, 4, // 30 - 37
  4, 4, 4, 4, 4, 4, 4, 4, // 38 - 3f
  4, 4, 4, 4, 4, 4, 4, 4, // 40 - 47
  4, 4, 4, 4, 4, 4, 4, 4, // 48 - 4f
  4, 4, 4, 4, 4, 4, 4, 4, // 50 - 57
  4, 4, 4, 4, 4, 4, 4, 4, // 58 - 5f
  4, 4, 4, 4, 4, 4, 4, 4, // 60 - 67
  4, 4, 4, 4, 4, 4, 4, 4, // 68 - 6f
  4, 4, 4, 4, 4, 4, 4, 4, // 70 - 77
  4, 4, 4, 4, 4, 4, 4, 4, // 78 - 7f
  5, 5, 5, 5, 5, 5, 5, 5, // 80 - 87
  5, 5, 5, 5, 5, 5, 1, 3, // 88 - 8f
  5, 5, 5, 5, 5, 5, 5, 5, // 90 - 97
  5, 5, 5, 5, 5, 5, 5, 5, // 98 - 9f
  5, 2, 2, 2, 2, 2, 2, 2, // a0 - a7
  2, 2, 2, 2, 2, 2, 2, 2, // a8 - af
  2, 2, 2, 2, 2, 2, 2, 2, // b0 - b7
  2, 2, 2, 2, 2, 2, 2, 2, // b8 - bf
  2, 2, 2, 2, 2, 2, 2, 2, // c0 - c7
  2, 2, 2, 2, 2, 2, 2, 2, // c8 - cf
  2, 2, 2, 2, 2, 2, 2, 2, // d0 - d7
  2, 2, 2, 2, 2, 2, 2, 2, // d8 - df
  0, 0, 0, 0, 0, 0, 0, 0, // e0 - e7
  0, 0, 0, 0, 0, 0, 0, 0, // e8 - ef
  0, 0, 0, 0, 0, 0, 0, 0, // f0 - f7
  0, 0, 0, 0, 0, 0, 0, 5, // f8 - ff
];

const _kEUCJPStateTable = [
  3, 4, 3, 5, eStart, eError, eError, eError, //00-07
  eError, eError, eError, eError, eItsMe, eItsMe, eItsMe, eItsMe, //08-0f
  eItsMe, eItsMe, eStart, eError, eStart, eError, eError, eError, //10-17
  eError, eError, eStart, eError, eError, eError, 3, eError, //18-1f
  3, eError, eError, eError, eStart, eStart, eStart, eStart, //20-27
];

const _kEUCJPCharLenTable = [2, 2, 2, 3, 1, 0];

const _kEUCKRClassTable = [
  // PCK4BITS(0,1,1,1,1,1,1,1),  // 00 - 07
  1, 1, 1, 1, 1, 1, 1, 1, // 00 - 07
  1, 1, 1, 1, 1, 1, 0, 0, // 08 - 0f
  1, 1, 1, 1, 1, 1, 1, 1, // 10 - 17
  1, 1, 1, 0, 1, 1, 1, 1, // 18 - 1f
  1, 1, 1, 1, 1, 1, 1, 1, // 20 - 27
  1, 1, 1, 1, 1, 1, 1, 1, // 28 - 2f
  1, 1, 1, 1, 1, 1, 1, 1, // 30 - 37
  1, 1, 1, 1, 1, 1, 1, 1, // 38 - 3f
  1, 1, 1, 1, 1, 1, 1, 1, // 40 - 47
  1, 1, 1, 1, 1, 1, 1, 1, // 48 - 4f
  1, 1, 1, 1, 1, 1, 1, 1, // 50 - 57
  1, 1, 1, 1, 1, 1, 1, 1, // 58 - 5f
  1, 1, 1, 1, 1, 1, 1, 1, // 60 - 67
  1, 1, 1, 1, 1, 1, 1, 1, // 68 - 6f
  1, 1, 1, 1, 1, 1, 1, 1, // 70 - 77
  1, 1, 1, 1, 1, 1, 1, 1, // 78 - 7f
  0, 0, 0, 0, 0, 0, 0, 0, // 80 - 87
  0, 0, 0, 0, 0, 0, 0, 0, // 88 - 8f
  0, 0, 0, 0, 0, 0, 0, 0, // 90 - 97
  0, 0, 0, 0, 0, 0, 0, 0, // 98 - 9f
  0, 2, 2, 2, 2, 2, 2, 2, // a0 - a7
  2, 2, 2, 2, 2, 3, 3, 3, // a8 - af
  2, 2, 2, 2, 2, 2, 2, 2, // b0 - b7
  2, 2, 2, 2, 2, 2, 2, 2, // b8 - bf
  2, 2, 2, 2, 2, 2, 2, 2, // c0 - c7
  2, 3, 2, 2, 2, 2, 2, 2, // c8 - cf
  2, 2, 2, 2, 2, 2, 2, 2, // d0 - d7
  2, 2, 2, 2, 2, 2, 2, 2, // d8 - df
  2, 2, 2, 2, 2, 2, 2, 2, // e0 - e7
  2, 2, 2, 2, 2, 2, 2, 2, // e8 - ef
  2, 2, 2, 2, 2, 2, 2, 2, // f0 - f7
  2, 2, 2, 2, 2, 2, 2, 0, // f8 - ff
];

const _kEUCKRStateTable = [
  eError, eStart, 3, eError, eError, eError, eError, eError, //00-07
  eItsMe, eItsMe, eItsMe, eItsMe, eError, eError, eStart, eStart, //08-0f
];

const _kEUCKRCharLenTable = [0, 1, 2, 0];

const _kJohabClassTable = [
  4, 4, 4, 4, 4, 4, 4, 4, // 00 - 07
  4, 4, 4, 4, 4, 4, 0, 0, // 08 - 0f
  4, 4, 4, 4, 4, 4, 4, 4, // 10 - 17
  4, 4, 4, 0, 4, 4, 4, 4, // 18 - 1f
  4, 4, 4, 4, 4, 4, 4, 4, // 20 - 27
  4, 4, 4, 4, 4, 4, 4, 4, // 28 - 2f
  4, 3, 3, 3, 3, 3, 3, 3, // 30 - 37
  3, 3, 3, 3, 3, 3, 3, 3, // 38 - 3f
  3, 1, 1, 1, 1, 1, 1, 1, // 40 - 47
  1, 1, 1, 1, 1, 1, 1, 1, // 48 - 4f
  1, 1, 1, 1, 1, 1, 1, 1, // 50 - 57
  1, 1, 1, 1, 1, 1, 1, 1, // 58 - 5f
  1, 1, 1, 1, 1, 1, 1, 1, // 60 - 67
  1, 1, 1, 1, 1, 1, 1, 1, // 68 - 6f
  1, 1, 1, 1, 1, 1, 1, 1, // 70 - 77
  1, 1, 1, 1, 1, 1, 1, 2, // 78 - 7f
  6, 6, 6, 6, 8, 8, 8, 8, // 80 - 87
  8, 8, 8, 8, 8, 8, 8, 8, // 88 - 8f
  8, 7, 7, 7, 7, 7, 7, 7, // 90 - 97
  7, 7, 7, 7, 7, 7, 7, 7, // 98 - 9f
  7, 7, 7, 7, 7, 7, 7, 7, // a0 - a7
  7, 7, 7, 7, 7, 7, 7, 7, // a8 - af
  7, 7, 7, 7, 7, 7, 7, 7, // b0 - b7
  7, 7, 7, 7, 7, 7, 7, 7, // b8 - bf
  7, 7, 7, 7, 7, 7, 7, 7, // c0 - c7
  7, 7, 7, 7, 7, 7, 7, 7, // c8 - cf
  7, 7, 7, 7, 5, 5, 5, 5, // d0 - d7
  5, 9, 9, 9, 9, 9, 9, 5, // d8 - df
  9, 9, 9, 9, 9, 9, 9, 9, // e0 - e7
  9, 9, 9, 9, 9, 9, 9, 9, // e8 - ef
  9, 9, 9, 9, 9, 9, 9, 9, // f0 - f7
  9, 9, 5, 5, 5, 5, 5, 0, // f8 - ff
];

const _kJohabStateTable = [
  eError, eStart, eStart, eStart, eStart, eError, eError, 3, //00-07
  3, 4, eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, //08-0f
  eItsMe, eItsMe, eItsMe, eItsMe, eError, eError, eError, eError, //10-17
  eError, eError, eError, eError, eError, eError, eError, eStart, //18-1f
  eStart, eError, eError, eStart, eStart, eStart, eStart, eStart, //20-27
  eError, eStart, eError, eStart, eError, eStart, eError, eStart, //28-2f
  eError, eStart, eStart, eStart, eStart, eStart, eStart, eStart, //30-37
];

const _kJohabCharLenTable = [0, 1, 1, 1, 1, 0, 0, 2, 2, 2];

const _kEUCTWClassTable = [
  // PCK4BITS(0,2,2,2,2,2,2,2),  // 00 - 07
  2, 2, 2, 2, 2, 2, 2, 2, // 00 - 07
  2, 2, 2, 2, 2, 2, 0, 0, // 08 - 0f
  2, 2, 2, 2, 2, 2, 2, 2, // 10 - 17
  2, 2, 2, 0, 2, 2, 2, 2, // 18 - 1f
  2, 2, 2, 2, 2, 2, 2, 2, // 20 - 27
  2, 2, 2, 2, 2, 2, 2, 2, // 28 - 2f
  2, 2, 2, 2, 2, 2, 2, 2, // 30 - 37
  2, 2, 2, 2, 2, 2, 2, 2, // 38 - 3f
  2, 2, 2, 2, 2, 2, 2, 2, // 40 - 47
  2, 2, 2, 2, 2, 2, 2, 2, // 48 - 4f
  2, 2, 2, 2, 2, 2, 2, 2, // 50 - 57
  2, 2, 2, 2, 2, 2, 2, 2, // 58 - 5f
  2, 2, 2, 2, 2, 2, 2, 2, // 60 - 67
  2, 2, 2, 2, 2, 2, 2, 2, // 68 - 6f
  2, 2, 2, 2, 2, 2, 2, 2, // 70 - 77
  2, 2, 2, 2, 2, 2, 2, 2, // 78 - 7f
  0, 0, 0, 0, 0, 0, 0, 0, // 80 - 87
  0, 0, 0, 0, 0, 0, 6, 0, // 88 - 8f
  0, 0, 0, 0, 0, 0, 0, 0, // 90 - 97
  0, 0, 0, 0, 0, 0, 0, 0, // 98 - 9f
  0, 3, 4, 4, 4, 4, 4, 4, // a0 - a7
  5, 5, 1, 1, 1, 1, 1, 1, // a8 - af
  1, 1, 1, 1, 1, 1, 1, 1, // b0 - b7
  1, 1, 1, 1, 1, 1, 1, 1, // b8 - bf
  1, 1, 3, 1, 3, 3, 3, 3, // c0 - c7
  3, 3, 3, 3, 3, 3, 3, 3, // c8 - cf
  3, 3, 3, 3, 3, 3, 3, 3, // d0 - d7
  3, 3, 3, 3, 3, 3, 3, 3, // d8 - df
  3, 3, 3, 3, 3, 3, 3, 3, // e0 - e7
  3, 3, 3, 3, 3, 3, 3, 3, // e8 - ef
  3, 3, 3, 3, 3, 3, 3, 3, // f0 - f7
  3, 3, 3, 3, 3, 3, 3, 0, // f8 - ff
];

const _kEUCTWStateTable = [
  eError, eError, eStart, 3, 3, 3, 4, eError, //00-07
  eError, eError, eError, eError, eError, eError, eItsMe, eItsMe, //08-0f
  eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, eError, eStart, eError, //10-17
  eStart, eStart, eStart, eError, eError, eError, eError, eError, //18-1f
  5, eError, eError, eError, eStart, eError, eStart, eStart, //20-27
  eStart, eError, eStart, eStart, eStart, eStart, eStart, eStart, //28-2f
];

const _kEUCTWCharLenTable = [0, 0, 1, 2, 2, 2, 3];

// the following state machine data was created by perl script in
// intl/chardet/tools. It should be the same as in PSM detector.
const _kGB18030ClassTable = [
  1, 1, 1, 1, 1, 1, 1, 1, // 00 - 07
  1, 1, 1, 1, 1, 1, 0, 0, // 08 - 0f
  1, 1, 1, 1, 1, 1, 1, 1, // 10 - 17
  1, 1, 1, 0, 1, 1, 1, 1, // 18 - 1f
  1, 1, 1, 1, 1, 1, 1, 1, // 20 - 27
  1, 1, 1, 1, 1, 1, 1, 1, // 28 - 2f
  3, 3, 3, 3, 3, 3, 3, 3, // 30 - 37
  3, 3, 1, 1, 1, 1, 1, 1, // 38 - 3f
  2, 2, 2, 2, 2, 2, 2, 2, // 40 - 47
  2, 2, 2, 2, 2, 2, 2, 2, // 48 - 4f
  2, 2, 2, 2, 2, 2, 2, 2, // 50 - 57
  2, 2, 2, 2, 2, 2, 2, 2, // 58 - 5f
  2, 2, 2, 2, 2, 2, 2, 2, // 60 - 67
  2, 2, 2, 2, 2, 2, 2, 2, // 68 - 6f
  2, 2, 2, 2, 2, 2, 2, 2, // 70 - 77
  2, 2, 2, 2, 2, 2, 2, 4, // 78 - 7f
  5, 6, 6, 6, 6, 6, 6, 6, // 80 - 87
  6, 6, 6, 6, 6, 6, 6, 6, // 88 - 8f
  6, 6, 6, 6, 6, 6, 6, 6, // 90 - 97
  6, 6, 6, 6, 6, 6, 6, 6, // 98 - 9f
  6, 6, 6, 6, 6, 6, 6, 6, // a0 - a7
  6, 6, 6, 6, 6, 6, 6, 6, // a8 - af
  6, 6, 6, 6, 6, 6, 6, 6, // b0 - b7
  6, 6, 6, 6, 6, 6, 6, 6, // b8 - bf
  6, 6, 6, 6, 6, 6, 6, 6, // c0 - c7
  6, 6, 6, 6, 6, 6, 6, 6, // c8 - cf
  6, 6, 6, 6, 6, 6, 6, 6, // d0 - d7
  6, 6, 6, 6, 6, 6, 6, 6, // d8 - df
  6, 6, 6, 6, 6, 6, 6, 6, // e0 - e7
  6, 6, 6, 6, 6, 6, 6, 6, // e8 - ef
  6, 6, 6, 6, 6, 6, 6, 6, // f0 - f7
  6, 6, 6, 6, 6, 6, 6, 0, // f8 - ff
];

const _kGB18030StateTable =
[
  eError, eStart, eStart, eStart, eStart, eStart, 3, eError, //00-07
  eError, eError, eError, eError, eError, eError, eItsMe, eItsMe, //08-0f
  eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, eError, eError, eStart, //10-17
  4, eError, eStart, eStart, eError, eError, eError, eError, //18-1f
  eError, eError, 5, eError, eError, eError, eItsMe, eError, //20-27
  eError, eError, eStart, eStart, eStart, eStart, eStart, eStart, //28-2f
];

// To be accurate, the length of class 6 can be either 2 or 4.
// But it is not necessary to discriminate between the two since
// it is used for frequency analysis only, and we are validing
// each code range there as well. So it is safe to set it to be
// 2 here.
const _kGB18030CharLenTable = [0, 1, 1, 1, 1, 1, 2];

// sjis
const _kShiftJisClassTable =
[
  // PCK4BITS(0,1,1,1,1,1,1,1),  // 00 - 07
  1, 1, 1, 1, 1, 1, 1, 1, // 00 - 07
  1, 1, 1, 1, 1, 1, 0, 0, // 08 - 0f
  1, 1, 1, 1, 1, 1, 1, 1, // 10 - 17
  1, 1, 1, 0, 1, 1, 1, 1, // 18 - 1f
  1, 1, 1, 1, 1, 1, 1, 1, // 20 - 27
  1, 1, 1, 1, 1, 1, 1, 1, // 28 - 2f
  1, 1, 1, 1, 1, 1, 1, 1, // 30 - 37
  1, 1, 1, 1, 1, 1, 1, 1, // 38 - 3f
  2, 2, 2, 2, 2, 2, 2, 2, // 40 - 47
  2, 2, 2, 2, 2, 2, 2, 2, // 48 - 4f
  2, 2, 2, 2, 2, 2, 2, 2, // 50 - 57
  2, 2, 2, 2, 2, 2, 2, 2, // 58 - 5f
  2, 2, 2, 2, 2, 2, 2, 2, // 60 - 67
  2, 2, 2, 2, 2, 2, 2, 2, // 68 - 6f
  2, 2, 2, 2, 2, 2, 2, 2, // 70 - 77
  2, 2, 2, 2, 2, 2, 2, 1, // 78 - 7f
  3, 3, 3, 3, 3, 3, 3, 3, // 80 - 87
  3, 3, 3, 3, 3, 3, 3, 3, // 88 - 8f
  3, 3, 3, 3, 3, 3, 3, 3, // 90 - 97
  3, 3, 3, 3, 3, 3, 3, 3, // 98 - 9f
  // 0xa0 is illegal in sjis encoding, but some pages does
  // contain such byte. We need to be more error forgiven.
  2, 2, 2, 2, 2, 2, 2, 2, // a0 - a7
  2, 2, 2, 2, 2, 2, 2, 2, // a8 - af
  2, 2, 2, 2, 2, 2, 2, 2, // b0 - b7
  2, 2, 2, 2, 2, 2, 2, 2, // b8 - bf
  2, 2, 2, 2, 2, 2, 2, 2, // c0 - c7
  2, 2, 2, 2, 2, 2, 2, 2, // c8 - cf
  2, 2, 2, 2, 2, 2, 2, 2, // d0 - d7
  2, 2, 2, 2, 2, 2, 2, 2, // d8 - df
  3, 3, 3, 3, 3, 3, 3, 3, // e0 - e7
  3, 3, 3, 3, 3, 4, 4, 4, // e8 - ef
  4, 4, 4, 4, 4, 4, 4, 4, // f0 - f7
  4, 4, 4, 4, 4, 0, 0, 0, // f8 - ff
];

const _kShiftJisStateTable =
[
  eError, eStart, eStart, 3, eError, eError, eError, eError, //00-07
  eError, eError, eError, eError, eItsMe, eItsMe, eItsMe, eItsMe, //08-0f
  eItsMe, eItsMe, eError, eError, eStart, eStart, eStart, eStart, //10-17
];

const _kShiftJisCharLenTable = [0, 1, 1, 2, 0, 0];

const _kUTF8ClassTable =
[
  // PCK4BITS(0,1,1,1,1,1,1,1),  // 00 - 07
  1, 1, 1, 1, 1, 1, 1, 1, // 00 - 07  //allow 0x00 as a legal value
  1, 1, 1, 1, 1, 1, 0, 0, // 08 - 0f
  1, 1, 1, 1, 1, 1, 1, 1, // 10 - 17
  1, 1, 1, 0, 1, 1, 1, 1, // 18 - 1f
  1, 1, 1, 1, 1, 1, 1, 1, // 20 - 27
  1, 1, 1, 1, 1, 1, 1, 1, // 28 - 2f
  1, 1, 1, 1, 1, 1, 1, 1, // 30 - 37
  1, 1, 1, 1, 1, 1, 1, 1, // 38 - 3f
  1, 1, 1, 1, 1, 1, 1, 1, // 40 - 47
  1, 1, 1, 1, 1, 1, 1, 1, // 48 - 4f
  1, 1, 1, 1, 1, 1, 1, 1, // 50 - 57
  1, 1, 1, 1, 1, 1, 1, 1, // 58 - 5f
  1, 1, 1, 1, 1, 1, 1, 1, // 60 - 67
  1, 1, 1, 1, 1, 1, 1, 1, // 68 - 6f
  1, 1, 1, 1, 1, 1, 1, 1, // 70 - 77
  1, 1, 1, 1, 1, 1, 1, 1, // 78 - 7f
  2, 2, 2, 2, 3, 3, 3, 3, // 80 - 87
  4, 4, 4, 4, 4, 4, 4, 4, // 88 - 8f
  4, 4, 4, 4, 4, 4, 4, 4, // 90 - 97
  4, 4, 4, 4, 4, 4, 4, 4, // 98 - 9f
  5, 5, 5, 5, 5, 5, 5, 5, // a0 - a7
  5, 5, 5, 5, 5, 5, 5, 5, // a8 - af
  5, 5, 5, 5, 5, 5, 5, 5, // b0 - b7
  5, 5, 5, 5, 5, 5, 5, 5, // b8 - bf
  0, 0, 6, 6, 6, 6, 6, 6, // c0 - c7
  6, 6, 6, 6, 6, 6, 6, 6, // c8 - cf
  6, 6, 6, 6, 6, 6, 6, 6, // d0 - d7
  6, 6, 6, 6, 6, 6, 6, 6, // d8 - df
  7, 8, 8, 8, 8, 8, 8, 8, // e0 - e7
  8, 8, 8, 8, 8, 9, 8, 8, // e8 - ef
  10, 11, 11, 11, 11, 11, 11, 11, // f0 - f7
  12, 13, 13, 13, 14, 15, 0, 0, // f8 - ff
];

const _kUTF8StateTable = [
  eError, eStart, eError, eError, eError, eError, 12, 10, //00-07
  9, 11, 8, 7, 6, 5, 4, 3, //08-0f
  eError, eError, eError, eError, eError, eError, eError, eError, //10-17
  eError, eError, eError, eError, eError, eError, eError, eError, //18-1f
  eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, //20-27
  eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, //28-2f
  eError, eError, 5, 5, 5, 5, eError, eError, //30-37
  eError, eError, eError, eError, eError, eError, eError, eError, //38-3f
  eError, eError, eError, 5, 5, 5, eError, eError, //40-47
  eError, eError, eError, eError, eError, eError, eError, eError, //48-4f
  eError, eError, 7, 7, 7, 7, eError, eError, //50-57
  eError, eError, eError, eError, eError, eError, eError, eError, //58-5f
  eError, eError, eError, eError, 7, 7, eError, eError, //60-67
  eError, eError, eError, eError, eError, eError, eError, eError, //68-6f
  eError, eError, 9, 9, 9, 9, eError, eError, //70-77
  eError, eError, eError, eError, eError, eError, eError, eError, //78-7f
  eError, eError, eError, eError, eError, 9, eError, eError, //80-87
  eError, eError, eError, eError, eError, eError, eError, eError, //88-8f
  eError, eError, 12, 12, 12, 12, eError, eError, //90-97
  eError, eError, eError, eError, eError, eError, eError, eError, //98-9f
  eError, eError, eError, eError, eError, 12, eError, eError, //a0-a7
  eError, eError, eError, eError, eError, eError, eError, eError, //a8-af
  eError, eError, 12, 12, 12, eError, eError, eError, //b0-b7
  eError, eError, eError, eError, eError, eError, eError, eError, //b8-bf
  eError, eError, eStart, eStart, eStart, eStart, eError, eError, //c0-c7
  eError, eError, eError, eError, eError, eError, eError, eError, //c8-cf
];

const _kUTF8CharLenTable = [0, 1, 0, 0, 0, 0, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6];
// dart format on
