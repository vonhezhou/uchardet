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
 *			Proofpoint, Inc.
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

import './big5_prober.dart';
import './charset_prober.dart';
import './eucjp_prober.dart';
import './euckr_prober.dart';
import './euctw_prober.dart';
import './gb18030_prober.dart';
import './johab_prober.dart';
import './sjis_prober.dart';
import './types.dart';
import './utf8_prober.dart';

class MBCSGroupProber extends CharSetProber {
  static const _kCandidateThreshold = 0.3;

  @protected
  final List<CharSetProber> _mProbers;

  @protected
  int _mActiveNum = 0;

  @protected
  final List<CharSetCandidate> _mCandidates = [];

  @override
  List<CharSetCandidate> getCandidates() => _mCandidates;

  MBCSGroupProber({required LanguageFilter languageFilter})
    : _mProbers = _createProbers(languageFilter) {
    reset();
  }

  @override
  void reset() {
    for (var ii in _mProbers) {
      ii.reset();
    }
    _mActiveNum = _mProbers.length;
    _mCandidates.clear();

    super.reset();
  }

  @override
  ProberState feed(Uint8List aBuf) {
    for (var ii in _mProbers) {
      if (!ii.mActive) {
        continue;
      }

      var st = ii.feed(aBuf);
      if (st == ProberState.foundIt) {
        var newCandidate = ii.getCandidates().firstOrNull;
        if (newCandidate != null &&
            newCandidate.confidence > _kCandidateThreshold) {
          mState = ProberState.foundIt;
          break;
        }
      } else if (st == ProberState.notMe) {
        ii.mActive = false;
        _mActiveNum--;
        if (_mActiveNum <= 0) {
          mState = ProberState.notMe;
          break;
        }
      }
    }

    return mState;
  }

  @override
  void close() {
    for (var ii in _mProbers) {
      ii.close();
    }

    _mCandidates.clear();
    switch (mState) {
      case ProberState.notMe:
        _mCandidates.clear();
        break;
      default:
        for (var ii in _mProbers) {
          if (!ii.mActive) {
            continue;
          }

          var newList = ii.getCandidates();
          newList.removeWhere((c) => c.confidence < _kCandidateThreshold);
          _mCandidates.addAll(newList);
        }
        _mCandidates.sort((a, b) => b.confidence.compareTo(a.confidence));
    }
  }

  static List<CharSetProber> _createProbers(LanguageFilter langFilter) {
    var probers = <CharSetProber>[];
    probers.add(UTF8Prober());
    if (langFilter.isEnabled(LanguageFilterType.kJapanese)) {
      probers.addAll([
        SJISProber(langFilter.isOnly(LanguageFilterType.kJapanese)),
        EUCJPProber(langFilter.isOnly(LanguageFilterType.kJapanese)),
      ]);
    }

    if (langFilter.isEnabled(LanguageFilterType.kChineseSimplified)) {
      probers.add(
        GB18030Prober(langFilter.isOnly(LanguageFilterType.kChineseSimplified)),
      );
    }

    CharSetProber? pendingProber;
    if (langFilter.isEnabled(LanguageFilterType.kKorean)) {
      probers.add(EUCKRProber(langFilter.isOnly(LanguageFilterType.kKorean)));
      pendingProber = JohabProber(
        langFilter.isOnly(LanguageFilterType.kKorean),
      );
    }

    if (langFilter.isEnabled(LanguageFilterType.kChineseTraditional)) {
      probers.addAll([
        Big5Prober(),
        EUCTWProber(langFilter.isOnly(LanguageFilterType.kChineseTraditional)),
      ]);
    }

    if (pendingProber != null) {
      probers.add(pendingProber);
    }

    return probers;
  }
}
