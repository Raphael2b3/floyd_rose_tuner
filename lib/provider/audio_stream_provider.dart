import 'package:buffered_list_stream/buffered_list_stream.dart';
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
  encoder: AudioEncoder.pcm16bits,
  numChannels: 1,
  bitRate: 128000,
  sampleRate: PitchDetector.DEFAULT_SAMPLE_RATE,
);

@Riverpod(keepAlive: true)
Future<Stream<List<int>>?> audioStream(Ref ref) async {
  ref.onDispose(() async {
    await recorder.cancel();
    await recorder.dispose();
  });

  // Check and request permission if needed
  if (await recorder.hasPermission()) {
    var recordStream = await recorder.startStream(recordConfig);
    var audioSampleBufferedStream = bufferedListStream(
      recordStream.map((Uint8List event) => event.toList()),
      //The library converts a PCM16 to 8bits internally. So we need twice as many bytes
      PitchDetector.DEFAULT_BUFFER_SIZE * 2,
    );
    return audioSampleBufferedStream.asBroadcastStream();
  }
  return null;
}
