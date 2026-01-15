import 'dart:async';

import 'package:floyd_rose_tuner/provider/audio_stream_provider.dart';
import 'package:floyd_rose_tuner/utils/normalize_int16list.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'frequency_stream_provider.g.dart';



final pitchDetectorDart = PitchDetector();


@riverpod
Future<Stream<double>> frequencyStream(Ref ref) async {
  var stream = await ref.watch(audioStreamProvider.future);
  return stream!.asyncMap((sample) async {
    //print("length of sample: ${sample.length}");
    if (sample.length < PitchDetector.DEFAULT_BUFFER_SIZE)
      return 100;
    var result = await pitchDetectorDart.getPitchFromFloatBuffer(sample.normalizeInt16List());
    //print("${result.probability} , ${result.pitch} from frequency_stream_provider");
    return result.pitch;
  });
}