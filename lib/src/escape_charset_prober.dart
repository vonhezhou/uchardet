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

import './charset_prober.dart';
import './coding_state_machine.dart';
import './escape_sm_model.dart';
import './types.dart';

class EscapeCharSetProber extends CharSetProber {
  final List<CodingStateMachine> _mStateMachines = [];
  int _mActiveSMCount = 0;

  CharSetCandidate? _mCandidate;

  EscapeCharSetProber({required LanguageFilter langFilter}) {
    if (langFilter.isEnabled(LanguageFilterType.kChineseSimplified)) {
      _mStateMachines.add(
        CodingStateMachine(model: EscapeSmModels.kHZGB2312Model),
      );
      _mStateMachines.add(
        CodingStateMachine(model: EscapeSmModels.kISO2022CNModel),
      );
    }

    if (langFilter.isEnabled(LanguageFilterType.kJapanese)) {
      _mStateMachines.add(
        CodingStateMachine(model: EscapeSmModels.kISO2022JPModel),
      );
    }

    if (langFilter.isEnabled(LanguageFilterType.kKorean)) {
      _mStateMachines.add(
        CodingStateMachine(model: EscapeSmModels.kISO2022KRModel),
      );
    }

    reset();
  }

  @override
  List<CharSetCandidate> getCandidates() => [
    if (_mCandidate != null) _mCandidate!,
  ];

  @override
  void reset() {
    super.reset();

    for (var ii in _mStateMachines) {
      ii.reset();
    }
    _mActiveSMCount = _mStateMachines.length;
    _mCandidate = null;
  }

  @override
  ProberState feed(Uint8List aBuf) {
    for (var ii in aBuf) {
      for (var oneSM in _mStateMachines) {
        if (!oneSM.mActive) {
          continue;
        }
        var codingState = oneSM.nextState(ii);
        if (codingState == eError) {
          oneSM.mActive = false;

          _mActiveSMCount -= 1;
          if (_mActiveSMCount <= 0) {
            super.mState = ProberState.notMe;
            return mState;
          }
        } else if (codingState == eItsMe) {
          mState = ProberState.foundIt;
          _mCandidate = CharSetCandidate(
            encoding: oneSM.model.encoding,
            language: oneSM.model.language,
            confidence: 0.99,
          );
          return mState;
        }
      }
    }
    return mState;
  }
}
