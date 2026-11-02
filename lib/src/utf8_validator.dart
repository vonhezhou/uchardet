import 'dart:typed_data';

import './types.dart';

/// 直接校验原始字节，不使用经过探测器过滤的数据或语言模型。
class Utf8Validator {
  Utf8Validity validity = Utf8Validity.pending;
  int _remaining = 0;
  int _nextMin = 0x80;
  int _nextMax = 0xbf;

  void reset() {
    validity = Utf8Validity.pending;
    _remaining = 0;
    _nextMin = 0x80;
    _nextMax = 0xbf;
  }

  void feed(Uint8List bytes) {
    if (validity != Utf8Validity.pending) return;
    for (final byte in bytes) {
      if (_remaining > 0) {
        if (byte < _nextMin || byte > _nextMax) {
          validity = Utf8Validity.invalid;
          return;
        }
        _remaining--;
        _nextMin = 0x80;
        _nextMax = 0xbf;
      } else if (byte <= 0x7f) {
        continue;
      } else if (byte >= 0xc2 && byte <= 0xdf) {
        _remaining = 1;
      } else if (byte >= 0xe0 && byte <= 0xef) {
        _remaining = 2;
        // 排除过长编码和 UTF-16 代理项。
        _nextMin = byte == 0xe0 ? 0xa0 : 0x80;
        _nextMax = byte == 0xed ? 0x9f : 0xbf;
      } else if (byte >= 0xf0 && byte <= 0xf4) {
        _remaining = 3;
        // Unicode 标量值上限为 U+10FFFF。
        _nextMin = byte == 0xf0 ? 0x90 : 0x80;
        _nextMax = byte == 0xf4 ? 0x8f : 0xbf;
      } else {
        validity = Utf8Validity.invalid;
        return;
      }
    }
  }

  void close() {
    if (validity != Utf8Validity.pending) return;
    validity = _remaining == 0 ? Utf8Validity.valid : Utf8Validity.invalid;
  }
}
