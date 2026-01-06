import 'dart:typed_data';

import 'package:floyd_rose_tuner/provider/audio_stream_provider.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'frequency_stream_provider.g.dart';


const int sampleRate = 44100;
const int bufferSize = 2048;
const int bitsPerSample = 8;
const int bitrate = bitsPerSample*sampleRate;

final pitchDetectorDart = PitchDetector(
    audioSampleRate: sampleRate*1,
    bufferSize: PitchDetector.DEFAULT_BUFFER_SIZE as int,
);


@riverpod
Future<Stream<double>> frequencyStream(Ref ref) async {
  var stream = await ref.watch(audioStreamProvider.future);
  // TODO: consider using the current string to help optimise the frequency detection
  return stream!.asyncMap((sample) async {
    print("Sample length: ${sample.length}");
    var result = await pitchDetectorDart.getPitchFromIntBuffer(sample);
    //print("${result.probability} , ${result.pitch} from frequency_stream_provider");
    return result.pitch;
  });
}