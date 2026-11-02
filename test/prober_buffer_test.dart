import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:uchardet/src/charset_prober.dart';
import 'package:uchardet/src/coding_state_machine.dart';
import 'package:uchardet/src/mbcs_sm_model.dart';
import 'package:uchardet/uchardet.dart';

class _FilterProber extends CharSetProber {
  @override
  ProberState feed(Uint8List buf) => getState();

  @override
  List<CharSetCandidate> getCandidates() => const [];
}

void main() {
  test(
    'single-byte filtering keeps accented words and normalizes delimiters',
    () {
      final prober = _FilterProber();
      final cases = <String, String>{
        'ASCII only words': '',
        'abc café! déjà-vu': 'café déjà ',
        'é abc é': 'é é',
        'é\r\nété\t': 'é été ',
        'àbc': 'àbc',
        '': '',
      };
      for (final entry in cases.entries) {
        final bytes = Uint8List.fromList(entry.key.codeUnits);
        final original = bytes.toList();
        expect(
          prober.filterWithoutEnglishLetters(bytes),
          entry.value.codeUnits,
        );
        expect(bytes, original, reason: '过滤不能覆盖调用者输入');
      }
    },
  );

  test('HTML filtering preserves upstream tag-boundary heuristics', () {
    final prober = _FilterProber();
    // 上游过滤器有特殊的标签边界行为，本轮性能优化保留该语义。
    final cases = <String, String>{
      '<b>café</b> déjà': 'b b déjà',
      '<tag attr="value">hello, world!</tag>': 'hello world tag ',
      'hello <unfinished': 'hello ',
      'café': 'café',
      '': '',
    };
    for (final entry in cases.entries) {
      expect(
        prober.filterWithEnglishLetters(
          Uint8List.fromList(entry.key.codeUnits),
        ),
        entry.value.codeUnits,
      );
    }
  });

  test(
    'filter grows, handles oversized input and remains reusable after reset',
    () {
      final prober = _FilterProber();
      for (final length in [1, 257, 65537, 3, 1024, 0]) {
        final bytes = Uint8List.fromList(List.filled(length, 0xe9));
        expect(prober.filterWithoutEnglishLetters(bytes), bytes);
        prober.reset();
        expect(
          prober.filterWithoutEnglishLetters(Uint8List.fromList([65, 32])),
          isEmpty,
        );
      }
    },
  );

  test('coding state machine asserts the byte input contract', () {
    final machine = CodingStateMachine(
      model: MBCSStateMachineModels.kUTF8Model,
    );
    expect(() => machine.nextState(-1), throwsA(isA<AssertionError>()));
    expect(() => machine.nextState(256), throwsA(isA<AssertionError>()));
    expect(machine.nextState(65), eStart);
  });
}
