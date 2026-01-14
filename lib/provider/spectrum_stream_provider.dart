import 'dart:async';

import 'package:floyd_rose_tuner/provider/audio_stream_provider.dart';
import 'package:floyd_rose_tuner/utils/normalize_int16list.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'spectrum_stream_provider.g.dart';



// Wenn der user die gitarre stimmt, dann wollen wir erkennen welche saite er
// gerade er verändert und automatisch switchen.
@riverpod
Future<Stream<double>> spectrumStream(Ref ref) async {
  var stream = await ref.watch(audioStreamProvider.future);
  return stream!.asyncMap((sample) async {
    //TODO Implement fft
    // helper methods in another provider:
    // TODO get highest peak near to a given frequency
    return 0;

  });
}