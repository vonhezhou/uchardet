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

import 'dart:typed_data';

import 'package:meta/meta.dart';

import './charset_prober.dart';
import './types.dart';

class CharSetGroupProber extends CharSetProber {
  @protected
  final List<CharSetProber> mProbers;

  @protected
  int mActiveNum = 0;

  @protected
  CharSetProber? mBestGuessProber;

  @protected
  final List<CharSetCandidate> mCandidates = [];

  @override
  List<CharSetCandidate> getCandidates() => mCandidates;

  CharSetGroupProber({required this.mProbers});

  @override
  void reset() {
    for (var ii in mProbers) {
      ii.reset();
    }
    mActiveNum = mProbers.length;
    mBestGuessProber = null;
    mCandidates.clear();

    super.reset();
  }

  @override
  ProberState feed(Uint8List aBuf) {
    for (var ii in mProbers) {
      if (!ii.mActive) {
        continue;
      }

      var st = ii.feed(aBuf);
      if (st == ProberState.foundIt) {
        mBestGuessProber = ii;
        mState = ProberState.foundIt;
        break;
      } else if (st == ProberState.notMe) {
        ii.mActive = false;
        mActiveNum--;
        if (mActiveNum <= 0) {
          mState = ProberState.notMe;
          break;
        }
      }
    }

    return mState;
  }

  @override
  void close() {
    for (var ii in mProbers) {
      ii.close();
    }

    mCandidates.clear();
    switch (mState) {
      case ProberState.foundIt:
        if (mBestGuessProber != null) {
          var newList = mBestGuessProber!.getCandidates();
          if (newList.isNotEmpty) {
            // only take one result
            mCandidates.add(newList.first);
          }
        }
        break;
      case ProberState.notMe:
        mCandidates.clear();
        break;
      default:
        var newMaxConfidence = 0.0;
        for (var ii in mProbers) {
          if (!ii.mActive) {
            continue;
          }

          var firstOnProber = ii.getCandidates().firstOrNull;
          if (firstOnProber == null) {
            continue;
          }

          if (firstOnProber.confidence > newMaxConfidence) {
            newMaxConfidence = firstOnProber.confidence;
            mBestGuessProber = ii;
          }
        }

        var candidate = mBestGuessProber?.getCandidates().firstOrNull;
        if (candidate != null) {
          mCandidates.add(candidate);
        }
    }
  }
}
