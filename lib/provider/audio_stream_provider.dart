import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_stream_provider.g.dart';

const int sampleRate = 44100;
const int bitrate = 8 * 44100;

var recorder = AudioRecorder();

var recordConfig = const RecordConfig(
  encoder: AudioEncoder.pcm16bits,
  sampleRate: sampleRate,
  bitRate: bitrate,
);

@riverpod
Future<Stream<Uint8List>?> audioStream(Ref ref) async {
  ref.onDispose(() async {
    await recorder.cancel();
    await recorder.dispose();
  });

  // Check and request permission if needed
  if (await recorder.hasPermission()) {
    var stream = await recorder.startStream(recordConfig);
    return stream;
  }
  return null;
}
