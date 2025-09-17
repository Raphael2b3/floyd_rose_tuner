import 'package:floyd_rose_tuner/provider/audio_stream_provider.dart';
import 'package:floyd_rose_tuner/utils/random_stream.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'frequency_stream_provider.g.dart';




const int sampleRate = 44100;
const int bufferSize = 2048;
const int bitsPerSample = 8;
const int bitrate = bitsPerSample*sampleRate;

final pitchDetectorDart = PitchDetector(
    audioSampleRate: sampleRate*1, bufferSize: bufferSize);


@riverpod
Future<Stream<double>> frequencyStream(Ref ref) async {
  var stream = await ref.watch(audioStreamProvider.future);
  return inputStream().asBroadcastStream();
  stream!.asyncMap((sample) async {
    var result = await pitchDetectorDart.getPitchFromIntBuffer(sample);
    print("${result.probability} from frequency_stream_provider");
    return result.pitch;
  });
}