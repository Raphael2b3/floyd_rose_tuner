import 'package:floyd_rose_tuner/utils/pcm16_encoding_to_Int16List.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_stream_provider.g.dart';

const int sampleRate = 44100;
const int bitrate = 8 * 44100;

var recorder = AudioRecorder();

var recordConfig = const RecordConfig(
  autoGain: false,
  encoder: AudioEncoder.pcm16bits,
  numChannels: 1,
  bitRate: 128000,
  sampleRate: PitchDetector.DEFAULT_SAMPLE_RATE,
  streamBufferSize: PitchDetector.DEFAULT_BUFFER_SIZE*2
);

@Riverpod(keepAlive: true)
Future<Stream<Int16List>?> audioStream(Ref ref) async {
  ref.onDispose(() async {
    await recorder.cancel();
    await recorder.dispose();
  });
  // TODO Pitch detection doesnt work stable
  // TODO dont use Pitchdetector
  // Check and request permission if needed
  if (await recorder.hasPermission()) {
    var recordStream = await recorder.startStream(recordConfig);
    return recordStream.asBroadcastStream().map((data) => bytesToInt16List(data));
  }
  return null;
}
