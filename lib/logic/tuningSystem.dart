import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:record/record.dart';

@riverpod
Stream<Uint8List> streamExample(Ref ref) async* {
  final record = AudioRecorder();
  ref.onDispose(() async {
    await record.cancel();
    await record.dispose();
  });
  // Check and request permission if needed
  if (await record.hasPermission()) {
    var stream = await record
        .startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
    await for (Uint8List data in stream) {
      yield data;
    }
  }
}
