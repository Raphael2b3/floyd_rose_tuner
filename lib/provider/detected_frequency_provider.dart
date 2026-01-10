import 'package:async/async.dart';
import 'package:floyd_rose_tuner/provider/smoothed_frequency_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/volume_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/volume_threshold_provider.dart';
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'detected_frequency_provider.g.dart';


@riverpod
class DetectedFrequencyNotifier extends _$DetectedFrequencyNotifier {
  @override
  Future<double> build() async  {
    // explizite Typen hilfen dem Analyzer bei der Typinferenz
    Stream<double> smoothedFrequency = await ref.watch(
      smoothedFrequencyStreamProvider().future,
    );
    Stream<double> volumeStream = await ref.watch(volumeStreamProvider.future);
    print(
      "detectedFrequencyProvider: obtained smoothedFrequency and volume streams",
    );
    // Create a combined stream of [frequency, volume]
    final combinedStream = StreamZip<double>(<Stream<double>>[
      smoothedFrequency,
      volumeStream,
    ]); // parallelized
    // For each incoming pair, update the buffer (only if volume >= threshold) and emit the
    // squared moving average (RMS) of the values in the buffer. If buffer is empty emit 0.0.
    combinedStream.listen((sample) {
      final frequency = sample[0];
      final volume = sample[1];
      if (frequency <= 0) {
        return;
      }
      final threshold = ref.read(volumeThresholdProvider);
      if (volume < threshold) {
        return;
      }
      state = AsyncValue.data(frequency);
    });
    return 0.0;
  }

  void setDetectedFrequency(double frequency) {
    state = AsyncValue.data(frequency);
  }
}
