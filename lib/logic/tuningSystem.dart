import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'dart:typed_data';


typedef Result = int; //Uint8List;
@riverpod
Stream<Result> streamExample(Ref ref) async* {}

final name = StreamNotifierProvider<AudioPitch, Result>(
    AudioPitch.new); //.someModifier<AudioPitch, Result>(AudioPitch.new);

class AudioPitch extends StreamNotifier<Result> {

  static const int sampleRate = 44100;
  static const int bufferSize = 2048;
  static const int bitsPerSample = 8;
  static const int bitrate = 8*44100;

  @override
  Stream<Result> build() async* {
    //Create a new pitch detector and set the sample rate and buffer size
    final pitchDetectorDart = PitchDetector(
        audioSampleRate: sampleRate*1, bufferSize: bufferSize);


    var recorder = AudioRecorder();
    var recordConfig = const RecordConfig(encoder: AudioEncoder.pcm16bits, sampleRate: sampleRate, bitRate: bitrate );
    ref.onDispose(() async {
      await recorder.cancel();
      await recorder.dispose();
    });

    // Check and request permission if needed
    if (await recorder.hasPermission()) {
      var stream = await recorder
          .startStream(recordConfig);
      await for (Uint8List sample in stream) {
        final result = pitchDetectorDart.getPitchFromIntBuffer(sample);

        yield sample.length;
      }
    }
  }

}
