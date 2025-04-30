import 'dart:typed_data';

import 'package:uchardet/uchardet.dart';

void main() {
  final detector = UCharDet(options: UCharDetOptions());
  // dart format off
  final utf8CN = Uint8List.fromList([ 0xE4, 0xB8, 0xAD, 0xE5, 0x8D, 0xB1, 0xE4, 0xBA, 0x8B, 0xE6, 0x96, 0x87, 0xE5, 0x8C, 0x97, 0xE5, 0x92, 0x8C, 0xE5, 0x9B, 0x9B, ]);
  // dart format on

  // for one-off detection
  printAllCanditates(detector.detect(utf8CN));
  // or access it from detector.candidates
  printAllCanditates(detector.candidates);

  // feed() can be called multiple times
  detector.reset();
  for (var ii in utf8CN) {
    if (detector.feed(Uint8List.fromList([ii]))) {
      break;
    }
  }
  detector.close();
  printAllCanditates(detector.candidates);
}

void printAllCanditates(List<CharSetCandidate> candidates) {
  if (candidates.isEmpty) {
    print('No candidates');
  } else {
    for (var ii in candidates) {
      print(ii);
    }
  }
}
