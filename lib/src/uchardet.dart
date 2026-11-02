/* -*- Mode: C++; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
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

import 'dart:math';
import 'dart:typed_data';

import './base/list_extensions.dart';
import './charset_prober.dart';
import './escape_charset_prober.dart';
import './mbcs_group_prober.dart';
import './sbcs_group_prober.dart';
import './types.dart';
import './utf8_validator.dart';
import 'base/ascii_utils.dart';

class UCharDetOptions {
  /// if you know the language of the text,
  /// use the LanguageFilter to specify it to decrease
  /// the number of probers we need to create.
  final LanguageFilter languageFilter;

  /// the minimum confidence to accept a candidate as result.
  /// for example, minConfidence = 0.2, then any candidate
  /// with a confidence lower than minConfidence will be ignored.
  /// @default 0.2
  final double minConfidence;

  /// 参与猜测的编码；null 表示不限制，空集合表示不进行编码猜测。
  /// 与 languageFilter 同时生效。BOM 明确声明的编码始终报告，
  /// 即使它不在集合内；调用者可据此处理编码声明与允许范围的冲突。
  /// 检测器创建时会复制集合，后续修改原集合不会影响检测。
  final Set<Encoding>? candidateEncodings;

  /// 独立校验所有送入的原始字节是否符合严格 UTF-8，不改变候选评分。
  /// 开启后仍需送入全文并 close()，不能因 feed() 返回 true 就停止送入。
  final bool validateUtf8;

  const UCharDetOptions({
    this.languageFilter = LanguageFilter.all,
    this.minConfidence = 0.2,
    this.candidateEncodings,
    this.validateUtf8 = false,
  });
}

enum _InputState { pureAscii, escapedAscii, highByte }

class UCharDet {
  CharSetCandidate? _mShortCircuitCandidate;
  final List<CharSetCandidate> _mCandidates = [];
  final List<CharSetCandidate> _mRawCandidates = [];
  final Map<Language, double> _mLanguageWeights = {};
  double _mDefaultWeight = 1.0;

  _InputState _mInputState = _InputState.pureAscii;

  int _mLastCodeUnit = 0;

  final List<int> _mBomBuffer = [];
  bool _mBomChecked = false;

  final UCharDetOptions _mOptions;
  final Set<Encoding>? _candidateEncodings;
  final Utf8Validator? _utf8Validator;

  bool _allows(Encoding encoding) =>
      _candidateEncodings?.contains(encoding) ?? true;

  /// 独立于语言统计的 UTF-8 合法性。有效只代表送入的字节可按 UTF-8 解码，
  /// 不证明原编码；close() 前保持 pending，发现非法序列则立即为 invalid。
  /// 未开启 validateUtf8 时为 notChecked，reset() 会清除上次校验状态。
  Utf8Validity get utf8Validity =>
      _utf8Validator?.validity ?? Utf8Validity.notChecked;

  final List<CharSetProber> _mCharSetProbers = [];
  CharSetProber? _mEscapeCharSetProber;

  bool _mNbspFound = false;

  bool _mDone = false;

  bool _mIsClosed = false;

  UCharDet({UCharDetOptions options = const UCharDetOptions()})
    : _mOptions = options,
      _candidateEncodings =
          options.candidateEncodings == null
              ? null
              : Set.unmodifiable(options.candidateEncodings!),
      _utf8Validator = options.validateUtf8 ? Utf8Validator() : null {
    reset();
  }

  /// return all possible candidates,
  ///  sorted by confidence the first candidate is the best one
  List<CharSetCandidate> get candidates => _mCandidates;

  /// 设置指定语言的置信度权重，并立即重新排列已有候选。
  /// 权重必须为有限非负数；0 可将该语言的排序权重降为 0。
  /// 权重在 [reset] 和 [detect] 之间保留。
  void weighLanguage(Language language, double weight) {
    _validateWeight(weight);
    _mLanguageWeights[language] = weight;
    _updateWeightedCandidates();
  }

  /// 设置未单独指定权重的语言及未知语言候选的默认权重。
  /// 权重仅影响最终置信度和排序，不改变探测与候选筛选过程。
  void setDefaultWeight(double weight) {
    _validateWeight(weight);
    _mDefaultWeight = weight;
    _updateWeightedCandidates();
  }

  static void _validateWeight(double weight) {
    if (!weight.isFinite || weight < 0) {
      throw ArgumentError.value(weight, 'weight', '必须为有限非负数');
    }
  }

  void _updateWeightedCandidates() {
    _mCandidates.clear();
    if (_mDefaultWeight == 1.0 && _mLanguageWeights.isEmpty) {
      _mCandidates.addAll(_mRawCandidates);
      return;
    }
    for (final candidate in _mRawCandidates) {
      final weight = _mLanguageWeights[candidate.language] ?? _mDefaultWeight;
      final weighted =
          weight == 1.0
              ? candidate
              : CharSetCandidate(
                encoding: candidate.encoding,
                language: candidate.language,
                confidence: candidate.confidence * weight,
                hasBom: candidate.hasBom,
              );
      final index = _mCandidates.indexWhere(
        (c) => c.confidence < weighted.confidence,
      );
      if (index < 0) {
        _mCandidates.add(weighted);
      } else {
        _mCandidates.insert(index, weighted);
      }
    }
  }

  /// detect the encoding of the given buffer
  List<CharSetCandidate> detect(Uint8List aBuf) {
    reset();

    feed(aBuf);

    close();
    return _mCandidates;
  }

  /// clear the internal state of the detector,
  /// so that we can start a new detection.
  void reset() {
    _mDone = false;
    _mIsClosed = false;
    _utf8Validator?.reset();

    _mNbspFound = false;
    _mInputState = _InputState.pureAscii;
    _mLastCodeUnit = 0;
    _mBomBuffer.clear();
    _mBomChecked = false;

    _mEscapeCharSetProber?.reset();

    for (var ii in _mCharSetProbers) {
      ii.reset();
    }

    _mShortCircuitCandidate = null;
    _mRawCandidates.clear();
    _mCandidates.clear();
  }

  /// feed the detector with a chunk of data,
  /// this function can be called multiple times.
  /// @param aBuf the buffer of bytes to feed into the detector.
  /// @return true if the detector already figured out the encoding.
  /// the return value is the same with isDone.
  /// 开启 validateUtf8 时，即使返回 true 也应继续送入剩余字节，
  /// 最后调用 close()，才能得到全文校验结果。close() 后的输入会忽略。
  bool feed(Uint8List aBuf) {
    if (_mIsClosed) return _mDone;
    // 编码探测可以提前结束，合法性校验必须继续消费后续原始输入。
    _utf8Validator?.feed(aBuf);
    if (_mDone) {
      return true;
    }

    var aLen = aBuf.length;
    if (aLen <= 0) {
      return _mDone;
    }

    if (!_mBomChecked) {
      // 开头字节只处理一次；保留 FF FE 的歧义，直到取得第 4 字节或结束。
      final prefixLength = min(aBuf.length, 4 - _mBomBuffer.length);
      for (var i = 0; i < prefixLength; i++) {
        _mBomBuffer.add(aBuf[i]);
      }
      _tryDetectBom();
      if (_mShortCircuitCandidate != null) {
        _mDone = true;
        return true;
      }
      if (_mBomBuffer.length < 4) {
        return false;
      }
      _mBomChecked = true;
      if (prefixLength == 4) return _feedData(aBuf);
      final combined = Uint8List(
        _mBomBuffer.length + aBuf.length - prefixLength,
      );
      combined.setRange(0, _mBomBuffer.length, _mBomBuffer);
      combined.setRange(
        _mBomBuffer.length,
        combined.length,
        aBuf,
        prefixLength,
      );
      return _feedData(combined);
    }

    return _feedData(aBuf);
  }

  bool _feedData(Uint8List aBuf) {
    if (_mInputState != _InputState.highByte) {
      for (var ii in aBuf) {
        // We got a non-ASCII byte (high-byte)
        // 0xA0 (NBSP in a few charset) is apparently a rare exception of non-ASCII character often contained in nearly-ASCII text.
        if (isNonAsciiHighByte(ii) && ii != 0xA0) {
          _mInputState = _InputState.highByte;
          // kill _escapeCharSetProber if it is active
          _mEscapeCharSetProber?.reset();
          _mEscapeCharSetProber = null;
          break;
        } else {
          /* ASCII with the only exception of NBSP seems quite common.
         * I doubt it is really necessary to train a model here, so let's
         * just make an exception.
         */
          if (ii == 0xA0) {
            _mNbspFound = true;
          } else if (_mInputState == _InputState.pureAscii &&
              // We found an escape character or HZ ~{.
              (ii == 0x1B || (_mLastCodeUnit == 0x7E && ii == 0x7B))) {
            _mInputState = _InputState.escapedAscii;
          }

          _mLastCodeUnit = ii;
        }
      }
    }

    switch (_mInputState) {
      case _InputState.escapedAscii:
        _mEscapeCharSetProber ??= EscapeCharSetProber(
          langFilter: _mOptions.languageFilter,
          candidateEncodings: _candidateEncodings,
        );

        if (_mEscapeCharSetProber!.feed(aBuf) == ProberState.foundIt) {
          _mShortCircuitCandidate =
              _mEscapeCharSetProber!.getCandidates().firstOrNull;
          _mDone = true;
        }
        break;
      case _InputState.highByte:
        {
          //start multibyte and singlebyte charset prober
          if (_mCharSetProbers.isEmpty) {
            _mCharSetProbers.add(
              MBCSGroupProber(
                languageFilter: _mOptions.languageFilter,
                candidateEncodings: _candidateEncodings,
              ),
            );

            if (_mOptions.languageFilter.isEnabled(
              LanguageFilterType.kNonCjk,
            )) {
              _mCharSetProbers.add(
                SBCSGroupProber(candidateEncodings: _candidateEncodings),
              );
            }

            /* Disabling the generic WINDOWS-1252 (Latin 1) prober for now.
          * We now have specific per-language models which are much more
          * efficients and useful. This is where we should direct our
          * efforts. Probably the whole nsLatin1Prober should disappear
          * at some point, but let's keep it for now, in case this was an
          * error.
          */
            // mCharSetProbers.add(nsLatin1Prober());
          }

          for (var ii in _mCharSetProbers) {
            if (ii.feed(aBuf) == ProberState.foundIt) {
              _mDone = true;
              break;
            }
          }
          break;
        }

      default:
        break;
    }

    return _mDone;
  }

  /// tell the detector that no more data to feed(),
  /// so that the detector can generate some results.
  void close() {
    if (_mIsClosed) {
      return;
    }
    _mIsClosed = true;
    _utf8Validator?.close();

    // 结束时才能确认仅有两字节的 UTF-16 BOM，或处理不足 4 字节的正文。
    if (_mBomBuffer.isEmpty) {
      return;
    }
    if (!_mBomChecked && _mShortCircuitCandidate == null) {
      _tryDetectBom(atEnd: true);
      _mBomChecked = true;
      if (_mShortCircuitCandidate == null) {
        _feedData(Uint8List.fromList(_mBomBuffer));
      }
    }

    _mEscapeCharSetProber?.close();
    for (var ii in _mCharSetProbers) {
      ii.close();
    }

    if (_mShortCircuitCandidate == null &&
        (_mInputState == _InputState.escapedAscii ||
            _mInputState == _InputState.pureAscii)) {
      if (_mNbspFound) {
        /* ISO-8859-1 is a good result candidate for ASCII + NBSP.
           * (though it could have been any ISO-8859 encoding). */
        _mShortCircuitCandidate = CharSetCandidate(
          encoding: Encoding.iso_8859_1,
          language: null,
          confidence: 0.99,
        );
      } else {
        // ASCII with the ESC character (or the sequence "~{") is still ASCII until proven otherwise.
        _mShortCircuitCandidate = CharSetCandidate(
          encoding: Encoding.ascii,
          language: null,
          confidence: 0.99,
        );
      }
    }

    if (_mShortCircuitCandidate != null) {
      /* These cases are limited enough that we are always confident
       * when finding them.
       */
      _mDone = true;
      _addCandidate(_mShortCircuitCandidate!);
      _updateWeightedCandidates();
      return;
    }

    if (_mInputState == _InputState.highByte) {
      for (var ii in _mCharSetProbers) {
        for (var jj in ii.getCandidates()) {
          if (jj.confidence < _mOptions.minConfidence) {
            continue;
          }

          _addCandidate(jj);
        }
      }
    }
    _updateWeightedCandidates();
  }

  void _addCandidate(CharSetCandidate newCandi) {
    // BOM 是明确声明，保留它以便调用者发现白名单冲突。
    if (!newCandi.hasBom && !_allows(newCandi.encoding)) return;
    var needToAddCandi = true;
    _mRawCandidates.removeWhere((c) {
      if (c.encoding == newCandi.encoding && c.language == newCandi.language) {
        // already reported with higher confidence, ignore newCandi
        if (c.confidence >= newCandi.confidence) {
          needToAddCandi = false;
          return false;
        }

        return true;
      }

      return false;
    });

    if (!needToAddCandi) {
      return;
    }

    // sort by confidence, highest confidence first
    final indexToInsert = _mRawCandidates.indexWhere(
      (c) => c.confidence < newCandi.confidence,
    );
    if (indexToInsert >= 0) {
      _mRawCandidates.insert(indexToInsert, newCandi);
    } else {
      _mRawCandidates.add(newCandi);
    }
  }

  void _tryDetectBom({bool atEnd = false}) {
    if (_mBomBuffer.startsWith([0xEF, 0xBB, 0xBF])) {
      /* EF BB BF: UTF-8 encoded BOM. */
      _mShortCircuitCandidate = CharSetCandidate(
        encoding: Encoding.utf8,
        language: null,
        confidence: 1.0,
        hasBom: true,
      );
    } else if (_mBomBuffer.startsWith([0xFF, 0xFE, 0x00, 0x00])) {
      /* FF FE 00 00: UTF-32 (LE). */
      _mShortCircuitCandidate = CharSetCandidate(
        encoding: Encoding.utf32le,
        language: null,
        confidence: 1.0,
        hasBom: true,
      );
    } else if (_mBomBuffer.startsWith([0x00, 0x00, 0xFE, 0xFF])) {
      /* 00 00 FE FF: UTF-32 (BE). */
      _mShortCircuitCandidate = CharSetCandidate(
        encoding: Encoding.utf32be,
        language: null,
        confidence: 1.0,
        hasBom: true,
      );
    } else if (_mBomBuffer.startsWith([0xFF, 0xFE]) &&
        (atEnd || _mBomBuffer.length == 4)) {
      // FF FE  UTF-16, little endian BOM
      _mShortCircuitCandidate = CharSetCandidate(
        encoding: Encoding.utf16le,
        language: null,
        confidence: 1.0,
        hasBom: true,
      );
    } else if (_mBomBuffer.startsWith([0xFE, 0xFF])) {
      // FE FF  UTF-16, big endian BOM
      _mShortCircuitCandidate = CharSetCandidate(
        encoding: Encoding.utf16be,
        language: null,
        confidence: 1.0,
        hasBom: true,
      );
    }
  }
}
