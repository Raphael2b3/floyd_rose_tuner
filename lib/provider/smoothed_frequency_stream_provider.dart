import 'dart:math';

import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'frequency_stream_provider.dart';

part 'smoothed_frequency_stream_provider.g.dart';

@riverpod
Future<Stream<double>> smoothedFrequencyStream(
  Ref ref, {
  int windowSize = 5,
}) async {
  var frequencyStream = await ref.watch(frequencyStreamProvider.future);
  // Ensure a sane window size
  final int window = (windowSize <= 0) ? 1 : windowSize;

  // sliding buffer storing the last `window` frequency samples (only samples above threshold)
  final List<double> buffer = [];

  // For each incoming pair, update the buffer (only if volume >= threshold) and emit the
  // squared moving average (RMS) of the values in the buffer. If buffer is empty emit 0.0.
  return frequencyStream.map((frequency) {
    if (frequency <= 0.0) {
      // ignore this sample; emit RMS of existing buffer (or 0 if empty)
      if (buffer.isEmpty) return 0.0;
      final sqSum = buffer.fold(0.0, (double prev, double v) => prev + v * v);
      return sqrt(sqSum / buffer.length);
    }

    // accept sample
    buffer.add(frequency);
    if (buffer.length > window) buffer.removeAt(0);

    final sqSum = buffer.fold(0.0, (double prev, double v) => prev + v * v);
    return sqrt(sqSum / buffer.length);
  });
}
