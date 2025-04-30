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

import 'package:uchardet/src/types.dart';

// state machine model
class StateMachineModel {
  final List<int> classTable;
  final List<int> stateTable;
  final List<int> charLenTable;
  final String name;
  final int classFactor;
  final Encoding encoding;
  final Language? language;

  const StateMachineModel({
    required this.classTable,
    required this.stateTable,
    required this.charLenTable,
    required this.classFactor,
    required this.name,
    required this.encoding,
    required this.language,
  });

  const StateMachineModel.cpp(
    List<int> classTable,
    int classFactor,
    List<int> stateTable,
    List<int> charLenTable,
    String name,
    Encoding encoding,
    Language? language,
  ) : this(
        classTable: classTable,
        classFactor: classFactor,
        stateTable: stateTable,
        charLenTable: charLenTable,
        name: name,
        encoding: encoding,
        language: language,
      );
}

/* Apart from these 3 generic states, machine states are specific to
 * each charset prober.
 */
const eStart = 0;
const eError = 1;
const eItsMe = 2;

class CodingStateMachine {
  int _mCurrentState = eStart;

  int _mCurrentCharLen = 0;

  final StateMachineModel model;

  int get state => _mCurrentState;

  int get currentCharLen => _mCurrentCharLen;

  bool mActive = true;

  CodingStateMachine({required this.model});

  // c should only be 8-bit value
  int nextState(int c) {
    AssertionError(c >= 0 && c < 256);

    //for each byte we get its class , if it is first byte, we also get byte length
    int byteCls = model.classTable[c];
    if (_mCurrentState == eStart) {
      _mCurrentCharLen = model.charLenTable[byteCls];
    }

    //from byte's class and stateTable, we get its next state
    _mCurrentState =
        model.stateTable[_mCurrentState * model.classFactor + byteCls];

    return _mCurrentState;
  }

  void reset() {
    _mCurrentState = eStart;
    mActive = true;
  }
}
