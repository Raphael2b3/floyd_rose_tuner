import 'dart:typed_data';

import 'package:floyd_rose_tuner/utils/bytes_to_int16list.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:statistics/statistics.dart';

part 'audio_stream_provider.g.dart';

const MIN_FREQUENCY = 30;
const MAX_FREQUENCY = 2000;
const NUM_CHANNELS = 1;
const SAMPLE_RATE = 44100; // 8 * MAX_FREQUENCY;
const BITRATE = 16 * SAMPLE_RATE * NUM_CHANNELS; // PCM 16 -> 16 bit pro sample
const BUFFER_SIZE = 2 * (BITRATE ~/ MIN_FREQUENCY);

var recorder = AudioRecorder();

var recordConfig = const RecordConfig(
  autoGain: false,
  encoder: AudioEncoder.pcm16bits,
  numChannels: 1,
  sampleRate: SAMPLE_RATE,
  streamBufferSize: 2 * 2048,
);

@Riverpod(keepAlive: true)
Future<Stream<List<int>>?> audioStream(Ref ref) async {
  ref.onDispose(() async {
    await recorder.cancel();
    await recorder.dispose();
  });

  if (await recorder.hasPermission()) {
    var recordStream = await recorder.startStream(recordConfig);
    return recordStream.asBroadcastStream().map((data) {
      //print("Audio Stream Data Length: ${data.length}");
      return bytesToInt16List(data);
    });
  }
  return null;
}

