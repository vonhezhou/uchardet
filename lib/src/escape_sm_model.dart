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
import './types.dart';

class EscapeSmModels {
  static const kHZGB2312Model = StateMachineModel(
    classTable: _kHZGB2312ClassTable,
    stateTable: _kHZGB2312StateTable,
    charLenTable: [0,0,0,0,0,0], 
    classFactor: 6,
    name: "HZ-GB-2312",
    encoding: Encoding.hzGB2312,
    language: Language.chinese,
  );

  static const kISO2022CNModel = StateMachineModel(
    classTable: _kISO2022CNClassTable,
    stateTable: _kISO2022CNStateTable,
    charLenTable: [0, 0, 0, 0, 0, 0, 0, 0, 0],
    classFactor: 9,
    name: "ISO-2022-CN",
    encoding: Encoding.iso2022CN,
    language: Language.chinese,
  );

  static const kISO2022JPModel = StateMachineModel(
    classTable: _kISO2022JPClassTable,
    stateTable: _kISO2022JPStateTable,
    charLenTable: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    classFactor: 10,
    name: "ISO-2022-JP",
    encoding: Encoding.iso2022JP,
    language: Language.japanese,
  );

  static const kISO2022KRModel = StateMachineModel(
    classTable: _kISO2022KRClassTable,
    stateTable: _kISO2022KRStateTable,
    charLenTable: [0, 0, 0, 0, 0, 0],
    classFactor: 6,
    name: "ISO-2022-KR",
    encoding: Encoding.iso2022KR,
    language: Language.korean,
  );
}

// dart format off
const _kHZGB2312ClassTable = [
  1, 0, 0, 0, 0, 0, 0, 0, // 00 - 07
  0, 0, 0, 0, 0, 0, 0, 0, // 08 - 0f
  0, 0, 0, 0, 0, 0, 0, 0, // 10 - 17
  0, 0, 0, 1, 0, 0, 0, 0, // 18 - 1f
  0, 0, 0, 0, 0, 0, 0, 0, // 20 - 27
  0, 0, 0, 0, 0, 0, 0, 0, // 28 - 2f
  0, 0, 0, 0, 0, 0, 0, 0, // 30 - 37
  0, 0, 0, 0, 0, 0, 0, 0, // 38 - 3f
  0, 0, 0, 0, 0, 0, 0, 0, // 40 - 47
  0, 0, 0, 0, 0, 0, 0, 0, // 48 - 4f
  0, 0, 0, 0, 0, 0, 0, 0, // 50 - 57
  0, 0, 0, 0, 0, 0, 0, 0, // 58 - 5f
  0, 0, 0, 0, 0, 0, 0, 0, // 60 - 67
  0, 0, 0, 0, 0, 0, 0, 0, // 68 - 6f
  0, 0, 0, 0, 0, 0, 0, 0, // 70 - 77
  0, 0, 0, 4, 0, 5, 2, 0, // 78 - 7f
  1, 1, 1, 1, 1, 1, 1, 1, // 80 - 87
  1, 1, 1, 1, 1, 1, 1, 1, // 88 - 8f
  1, 1, 1, 1, 1, 1, 1, 1, // 90 - 97
  1, 1, 1, 1, 1, 1, 1, 1, // 98 - 9f
  1, 1, 1, 1, 1, 1, 1, 1, // a0 - a7
  1, 1, 1, 1, 1, 1, 1, 1, // a8 - af
  1, 1, 1, 1, 1, 1, 1, 1, // b0 - b7
  1, 1, 1, 1, 1, 1, 1, 1, // b8 - bf
  1, 1, 1, 1, 1, 1, 1, 1, // c0 - c7
  1, 1, 1, 1, 1, 1, 1, 1, // c8 - cf
  1, 1, 1, 1, 1, 1, 1, 1, // d0 - d7
  1, 1, 1, 1, 1, 1, 1, 1, // d8 - df
  1, 1, 1, 1, 1, 1, 1, 1, // e0 - e7
  1, 1, 1, 1, 1, 1, 1, 1, // e8 - ef
  1, 1, 1, 1, 1, 1, 1, 1, // f0 - f7
  1, 1, 1, 1, 1, 1, 1, 1, // f8 - ff
];

const _kHZGB2312StateTable = [
  eStart, eError, 3, eStart, eStart, eStart, eError, eError, //00-07
  eError, eError, eError, eError, eItsMe, eItsMe, eItsMe, eItsMe, //08-0f
  eItsMe, eItsMe, eError, eError, eStart, eStart, 4, eError, //10-17
  5, eError, 6, eError, 5, 5, 4, eError, //18-1f
  4, eError, 4, 4, 4, eError, 4, eError, //20-27
  4, eItsMe, eStart, eStart, eStart, eStart, eStart, eStart, //28-2f
];

const _kISO2022CNClassTable =
  ([
    2, 0, 0, 0, 0, 0, 0, 0, // 00 - 07
    0, 0, 0, 0, 0, 0, 0, 0, // 08 - 0f
    0, 0, 0, 0, 0, 0, 0, 0, // 10 - 17
    0, 0, 0, 1, 0, 0, 0, 0, // 18 - 1f
    0, 0, 0, 0, 0, 0, 0, 0, // 20 - 27
    0, 3, 0, 0, 0, 0, 0, 0, // 28 - 2f
    0, 0, 0, 0, 0, 0, 0, 0, // 30 - 37
    0, 0, 0, 0, 0, 0, 0, 0, // 38 - 3f
    0, 0, 0, 4, 0, 0, 0, 0, // 40 - 47
    0, 0, 0, 0, 0, 0, 0, 0, // 48 - 4f
    0, 0, 0, 0, 0, 0, 0, 0, // 50 - 57
    0, 0, 0, 0, 0, 0, 0, 0, // 58 - 5f
    0, 0, 0, 0, 0, 0, 0, 0, // 60 - 67
    0, 0, 0, 0, 0, 0, 0, 0, // 68 - 6f
    0, 0, 0, 0, 0, 0, 0, 0, // 70 - 77
    0, 0, 0, 0, 0, 0, 0, 0, // 78 - 7f
    2, 2, 2, 2, 2, 2, 2, 2, // 80 - 87
    2, 2, 2, 2, 2, 2, 2, 2, // 88 - 8f
    2, 2, 2, 2, 2, 2, 2, 2, // 90 - 97
    2, 2, 2, 2, 2, 2, 2, 2, // 98 - 9f
    2, 2, 2, 2, 2, 2, 2, 2, // a0 - a7
    2, 2, 2, 2, 2, 2, 2, 2, // a8 - af
    2, 2, 2, 2, 2, 2, 2, 2, // b0 - b7
    2, 2, 2, 2, 2, 2, 2, 2, // b8 - bf
    2, 2, 2, 2, 2, 2, 2, 2, // c0 - c7
    2, 2, 2, 2, 2, 2, 2, 2, // c8 - cf
    2, 2, 2, 2, 2, 2, 2, 2, // d0 - d7
    2, 2, 2, 2, 2, 2, 2, 2, // d8 - df
    2, 2, 2, 2, 2, 2, 2, 2, // e0 - e7
    2, 2, 2, 2, 2, 2, 2, 2, // e8 - ef
    2, 2, 2, 2, 2, 2, 2, 2, // f0 - f7
    2, 2, 2, 2, 2, 2, 2, 2, // f8 - ff
  ]);

const _kISO2022CNStateTable =
  ([
    eStart, 3, eError, eStart, eStart, eStart, eStart, eStart, //00-07
    eStart, eError, eError, eError, eError, eError, eError, eError, //08-0f
    eError, eError, eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, //10-17
    eItsMe, eItsMe, eItsMe, eError, eError, eError, 4, eError, //18-1f
    eError, eError, eError, eItsMe, eError, eError, eError, eError, //20-27
    5, 6, eError, eError, eError, eError, eError, eError, //28-2f
    eError, eError, eError, eItsMe, eError, eError, eError, eError, //30-37
    eError, eError, eError, eError, eError, eItsMe, eError, eStart, //38-3f
  ]);

const _kISO2022JPClassTable =
  ([
    2, 0, 0, 0, 0, 0, 0, 0, // 00 - 07
    0, 0, 0, 0, 0, 0, 2, 2, // 08 - 0f
    0, 0, 0, 0, 0, 0, 0, 0, // 10 - 17
    0, 0, 0, 1, 0, 0, 0, 0, // 18 - 1f
    0, 0, 0, 0, 7, 0, 0, 0, // 20 - 27
    3, 0, 0, 0, 0, 0, 0, 0, // 28 - 2f
    0, 0, 0, 0, 0, 0, 0, 0, // 30 - 37
    0, 0, 0, 0, 0, 0, 0, 0, // 38 - 3f
    6, 0, 4, 0, 8, 0, 0, 0, // 40 - 47
    0, 9, 5, 0, 0, 0, 0, 0, // 48 - 4f
    0, 0, 0, 0, 0, 0, 0, 0, // 50 - 57
    0, 0, 0, 0, 0, 0, 0, 0, // 58 - 5f
    0, 0, 0, 0, 0, 0, 0, 0, // 60 - 67
    0, 0, 0, 0, 0, 0, 0, 0, // 68 - 6f
    0, 0, 0, 0, 0, 0, 0, 0, // 70 - 77
    0, 0, 0, 0, 0, 0, 0, 0, // 78 - 7f
    2, 2, 2, 2, 2, 2, 2, 2, // 80 - 87
    2, 2, 2, 2, 2, 2, 2, 2, // 88 - 8f
    2, 2, 2, 2, 2, 2, 2, 2, // 90 - 97
    2, 2, 2, 2, 2, 2, 2, 2, // 98 - 9f
    2, 2, 2, 2, 2, 2, 2, 2, // a0 - a7
    2, 2, 2, 2, 2, 2, 2, 2, // a8 - af
    2, 2, 2, 2, 2, 2, 2, 2, // b0 - b7
    2, 2, 2, 2, 2, 2, 2, 2, // b8 - bf
    2, 2, 2, 2, 2, 2, 2, 2, // c0 - c7
    2, 2, 2, 2, 2, 2, 2, 2, // c8 - cf
    2, 2, 2, 2, 2, 2, 2, 2, // d0 - d7
    2, 2, 2, 2, 2, 2, 2, 2, // d8 - df
    2, 2, 2, 2, 2, 2, 2, 2, // e0 - e7
    2, 2, 2, 2, 2, 2, 2, 2, // e8 - ef
    2, 2, 2, 2, 2, 2, 2, 2, // f0 - f7
    2, 2, 2, 2, 2, 2, 2, 2, // f8 - ff
  ]);

const _kISO2022JPStateTable = [
  eStart, 3, eError, eStart, eStart, eStart, eStart, eStart, //00-07
  eStart, eStart, eError, eError, eError, eError, eError, eError, //08-0f
  eError, eError, eError, eError, eItsMe, eItsMe, eItsMe, eItsMe, //10-17
  eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, eItsMe, eError, eError, //18-1f
  eError, 5, eError, eError, eError, 4, eError, eError, //20-27
  eError, eError, eError, 6, eItsMe, eError, eItsMe, eError, //28-2f
  eError, eError, eError, eError, eError, eError, eItsMe, eItsMe, //30-37
  eError, eError, eError, eItsMe, eError, eError, eError, eError, //38-3f
  eError, eError, eError, eError, eItsMe, eError, eStart, eStart, //40-47
];

const _kISO2022KRClassTable = [
  2, 0, 0, 0, 0, 0, 0, 0, // 00 - 07
  0, 0, 0, 0, 0, 0, 0, 0, // 08 - 0f
  0, 0, 0, 0, 0, 0, 0, 0, // 10 - 17
  0, 0, 0, 1, 0, 0, 0, 0, // 18 - 1f
  0, 0, 0, 0, 3, 0, 0, 0, // 20 - 27
  0, 4, 0, 0, 0, 0, 0, 0, // 28 - 2f
  0, 0, 0, 0, 0, 0, 0, 0, // 30 - 37
  0, 0, 0, 0, 0, 0, 0, 0, // 38 - 3f
  0, 0, 0, 5, 0, 0, 0, 0, // 40 - 47
  0, 0, 0, 0, 0, 0, 0, 0, // 48 - 4f
  0, 0, 0, 0, 0, 0, 0, 0, // 50 - 57
  0, 0, 0, 0, 0, 0, 0, 0, // 58 - 5f
  0, 0, 0, 0, 0, 0, 0, 0, // 60 - 67
  0, 0, 0, 0, 0, 0, 0, 0, // 68 - 6f
  0, 0, 0, 0, 0, 0, 0, 0, // 70 - 77
  0, 0, 0, 0, 0, 0, 0, 0, // 78 - 7f
  2, 2, 2, 2, 2, 2, 2, 2, // 80 - 87
  2, 2, 2, 2, 2, 2, 2, 2, // 88 - 8f
  2, 2, 2, 2, 2, 2, 2, 2, // 90 - 97
  2, 2, 2, 2, 2, 2, 2, 2, // 98 - 9f
  2, 2, 2, 2, 2, 2, 2, 2, // a0 - a7
  2, 2, 2, 2, 2, 2, 2, 2, // a8 - af
  2, 2, 2, 2, 2, 2, 2, 2, // b0 - b7
  2, 2, 2, 2, 2, 2, 2, 2, // b8 - bf
  2, 2, 2, 2, 2, 2, 2, 2, // c0 - c7
  2, 2, 2, 2, 2, 2, 2, 2, // c8 - cf
  2, 2, 2, 2, 2, 2, 2, 2, // d0 - d7
  2, 2, 2, 2, 2, 2, 2, 2, // d8 - df
  2, 2, 2, 2, 2, 2, 2, 2, // e0 - e7
  2, 2, 2, 2, 2, 2, 2, 2, // e8 - ef
  2, 2, 2, 2, 2, 2, 2, 2, // f0 - f7
  2, 2, 2, 2, 2, 2, 2, 2, // f8 - ff
];

const _kISO2022KRStateTable = [
  eStart, 3, eError, eStart, eStart, eStart, eError, eError, //00-07
  eError, eError, eError, eError, eItsMe, eItsMe, eItsMe, eItsMe, //08-0f
  eItsMe, eItsMe, eError, eError, eError, 4, eError, eError, //10-17
  eError, eError, eError, eError, 5, eError, eError, eError, //18-1f
  eError, eError, eError, eItsMe, eStart, eStart, eStart, eStart, //20-27
];
// dart format on