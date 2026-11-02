import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import '../benchmark/uchardet_benchmark.dart' as bench;
import 'package:uchardet/uchardet.dart';

// 需以 dart --enable-vm-service=0 运行；统计预热后固定工作量的累计分配。
Future<void> main() async {
  final info = await Service.getInfo();
  final uri = info.serverUri;
  if (uri == null) {
    stderr.writeln(
      'Run with dart --enable-vm-service=0 tools/profile_allocations.dart',
    );
    exitCode = 64;
    return;
  }
  final client = HttpClient();
  Future<Map<String, dynamic>> profile({bool reset = false}) async {
    final request = await client.getUrl(
      uri
          .resolve('getAllocationProfile')
          .replace(
            queryParameters: {
              'isolateId': Service.getIsolateId(Isolate.current)!,
              if (reset) 'reset': 'true',
            },
          ),
    );
    final response = await request.close();
    final data =
        jsonDecode(await utf8.decoder.bind(response).join())
            as Map<String, dynamic>;
    if (data.containsKey('error')) throw StateError('${data['error']}');
    return data['result'] as Map<String, dynamic>;
  }

  final inputs = bench.benchmarkInputs();
  final detector = UCharDet();
  for (var i = 0; i < 100; i++) {
    for (final bytes in inputs.values) {
      bench.consume(detector, bytes, 0);
    }
  }
  await profile(reset: true);
  for (var i = 0; i < 100; i++) {
    for (final bytes in inputs.values) {
      bench.consume(detector, bytes, 0);
    }
  }
  final result = await profile();
  final classes = <String, Object>{};
  for (final member in result['members'] as List) {
    final name = member['class']['name'] as String;
    if ([
      'CharSetCandidate',
      '_Uint8List',
      '_GrowableList',
      '_List',
      'AssertionError',
    ].contains(name)) {
      classes[name] = {
        'instances': member['instancesAccumulated'],
        'bytes': member['accumulatedSize'],
      };
    }
  }
  print(jsonEncode({'operations': 500, 'classes': classes}));
  client.close(force: true);
}
