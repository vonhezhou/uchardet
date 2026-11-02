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

import "./charset_prober.dart";
import './cjk_detector.dart';
import './coding_state_machine.dart';
import "./lang_models/lang_arabic_model.dart";
import "./lang_models/lang_belarusian_model.dart";
import "./lang_models/lang_bulgarian_model.dart";
import "./lang_models/lang_catalan_model.dart";
import "./lang_models/lang_croatian_model.dart";
import "./lang_models/lang_czech_model.dart";
import "./lang_models/lang_danish_model.dart";
import "./lang_models/lang_english_model.dart";
import "./lang_models/lang_esperanto_model.dart";
import "./lang_models/lang_estonian_model.dart";
import "./lang_models/lang_finnish_model.dart";
import "./lang_models/lang_french_model.dart";
import "./lang_models/lang_georgian_model.dart";
import "./lang_models/lang_german_model.dart";
import "./lang_models/lang_greek_model.dart";
import "./lang_models/lang_hebrew_model.dart";
import "./lang_models/lang_hindi_model.dart";
import "./lang_models/lang_hungarian_model.dart";
import "./lang_models/lang_irish_model.dart";
import "./lang_models/lang_italian_model.dart";
import "./lang_models/lang_latvian_model.dart";
import "./lang_models/lang_lithuanian_model.dart";
import "./lang_models/lang_macedonian_model.dart";
import "./lang_models/lang_maltese_model.dart";
import "./lang_models/lang_norwegian_model.dart";
import "./lang_models/lang_polish_model.dart";
import "./lang_models/lang_portuguese_model.dart";
import "./lang_models/lang_romanian_model.dart";
import "./lang_models/lang_russian_model.dart";
import "./lang_models/lang_serbian_model.dart";
import "./lang_models/lang_slovak_model.dart";
import "./lang_models/lang_slovene_model.dart";
import "./lang_models/lang_spanish_model.dart";
import "./lang_models/lang_swedish_model.dart";
import "./lang_models/lang_thai_model.dart";
import "./lang_models/lang_turkish_model.dart";
import "./lang_models/lang_ukrainian_model.dart";
import "./lang_models/lang_vietnamese_model.dart";
import './language_detector.dart';
import './mbcs_sm_model.dart';
import './types.dart';

class UTF8Prober extends CharSetProber {
  static const _kCandidateThreshold = 0.3;

  final CodingStateMachine _mCodingSM;
  int _mNumOfMBChar = 0;

  int _mCurrentCodePoint = 0;

  final List<int> _mCodePointBuffer = [];

  final List<LanguageDetector> _mLangDetectors = [];

  final List<CharSetCandidate> _mCandidates = [];
  bool _candidatesDirty = false;

  UTF8Prober()
    : _mCodingSM = CodingStateMachine(
        model: MBCSStateMachineModels.kUTF8Model,
      ) {
    _mLangDetectors.addAll(_createLanguageDetectors());
    reset();
  }

  @override
  List<CharSetCandidate> getCandidates() {
    _updateCandidates();
    return _mCandidates;
  }

  @override
  double get confidence {
    _flushCodePoints();
    final cf = _calcConfidence();
    for (final detector in _mLangDetectors) {
      final confidence = cf * detector.getConfidence();
      if (confidence > _kCandidateThreshold) return confidence;
    }
    return 0.0;
  }

  @override
  bool decodeToUnicode() => true;

  @override
  void reset() {
    _mCodingSM.reset();
    _mNumOfMBChar = 0;
    _mCurrentCodePoint = 0;

    _mCodePointBuffer.clear();
    _mCandidates.clear();
    _candidatesDirty = false;

    for (var jj in _mLangDetectors) {
      jj.reset();
    }

    super.reset();
  }

  /// 上游仅将过滤后的多字节片段送入编码状态机，其他 ASCII 仍参与语言统计。
  void feedCodePoint(int codePoint) {
    _mCodePointBuffer.add(codePoint);
    _candidatesDirty = true;
    if (_mCodePointBuffer.length >= 1024) {
      _flushCodePoints();
    }
  }

  void _flushCodePoints() {
    if (_mCodePointBuffer.isEmpty) return;
    for (final detector in _mLangDetectors) {
      detector.feed(_mCodePointBuffer);
    }
    _mCodePointBuffer.clear();
  }

  @override
  ProberState feed(Uint8List aBuf) {
    const enoughCharThreshold = 256;
    int codingState = 0;
    for (var i = 0; i < aBuf.length; i++) {
      codingState = _mCodingSM.nextState(aBuf[i]);
      if (codingState == eItsMe) {
        mState = ProberState.foundIt;
        break;
      }
      if (codingState == eStart) {
        var charLen = _mCodingSM.currentCharLen;
        if (charLen >= 2) {
          _mNumOfMBChar++;

          _mCurrentCodePoint =
              ((0xff & aBuf[i]) & 0x3f) | (_mCurrentCodePoint << 6);
          if (charLen == 2) {
            _mCurrentCodePoint &= 0x7ff;
          } else if (charLen == 3) {
            _mCurrentCodePoint &= 0xffff;
          } else {
            _mCurrentCodePoint &= 0x1fffff;
          }
        } else {
          _mCurrentCodePoint = 0xff & aBuf[i];
        }

        feedCodePoint(_mCurrentCodePoint);
        _mCurrentCodePoint = 0;
      } else {
        _mCurrentCodePoint =
            ((0xff & aBuf[i]) & 0x3f) | (_mCurrentCodePoint << 6);
      }
    }

    _flushCodePoints();

    if (mState == ProberState.detecting) {
      if (_mNumOfMBChar > enoughCharThreshold &&
          _calcConfidence() > CharSetProber.kShortcutThreshold) {
        mState = ProberState.foundIt;
      }
    }
    return mState;
  }

  @override
  void close() {
    _updateCandidates();
  }

  void _updateCandidates() {
    if (!_candidatesDirty) return;
    _flushCodePoints();
    _candidatesDirty = false;
    _mCandidates.clear();
    final cf = _calcConfidence();
    for (final detector in _mLangDetectors) {
      final confidence = cf * detector.getConfidence();
      if (confidence > _kCandidateThreshold) {
        _mCandidates.add(
          CharSetCandidate(
            encoding: Encoding.utf8,
            language: detector.getLanguage(),
            confidence: confidence,
          ),
        );
      }
    }
  }

  double _calcConfidence() {
    const oneCharProb = 0.50;

    if (_mNumOfMBChar < 6) {
      double unlike = 0.5;

      for (var i = 0; i < _mNumOfMBChar; i++) {
        unlike *= oneCharProb;
      }

      return 1.0 - unlike;
    } else {
      return 0.99;
    }
  }

  static List<LanguageDetector> _createLanguageDetectors() {
    return [
      LanguageDetector(mModel: ArabicModel),
      LanguageDetector(mModel: BelarusianModel),
      LanguageDetector(mModel: BulgarianModel),
      LanguageDetector(mModel: CatalanModel),
      LanguageDetector(mModel: CroatianModel),
      LanguageDetector(mModel: CzechModel),
      LanguageDetector(mModel: DanishModel),
      LanguageDetector(mModel: EnglishModel),
      LanguageDetector(mModel: EsperantoModel),
      LanguageDetector(mModel: EstonianModel),
      LanguageDetector(mModel: FinnishModel),
      LanguageDetector(mModel: FrenchModel),
      LanguageDetector(mModel: GermanModel),
      LanguageDetector(mModel: GeorgianModel),
      LanguageDetector(mModel: GreekModel),
      LanguageDetector(mModel: HebrewModel),
      LanguageDetector(mModel: HindiModel),
      LanguageDetector(mModel: HungarianModel),
      LanguageDetector(mModel: IrishModel),
      LanguageDetector(mModel: ItalianModel),
      LanguageDetector(mModel: LatvianModel),
      LanguageDetector(mModel: LithuanianModel),
      LanguageDetector(mModel: MacedonianModel),
      LanguageDetector(mModel: MalteseModel),
      LanguageDetector(mModel: NorwegianModel),
      LanguageDetector(mModel: PolishModel),
      LanguageDetector(mModel: PortugueseModel),
      LanguageDetector(mModel: RomanianModel),
      LanguageDetector(mModel: RussianModel),
      LanguageDetector(mModel: SerbianModel),
      LanguageDetector(mModel: SlovakModel),
      LanguageDetector(mModel: SloveneModel),
      LanguageDetector(mModel: SpanishModel),
      LanguageDetector(mModel: SwedishModel),
      LanguageDetector(mModel: ThaiModel),
      LanguageDetector(mModel: TurkishModel),
      LanguageDetector(mModel: UkrainianModel),
      LanguageDetector(mModel: VietnameseModel),
      CJKDetector(),
    ];
  }
}
