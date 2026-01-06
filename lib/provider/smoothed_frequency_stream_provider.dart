import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:floyd_rose_tuner/provider/volume_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/volume_threshold_provider.dart';
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'frequency_stream_provider.dart';
part 'smoothed_frequency_stream_provider.g.dart';



@riverpod
Future<Stream<double>> smoothedFrequencyStream(Ref ref) async {
  var frequencyStream = await ref.watch(frequencyStreamProvider.future);
  var volumeStream = await ref.watch(volumeStreamProvider.future);
  // TODO: Create a squared moving average, and ignore samples with volume below
  //  the threshold coming from a volume threashhold provider
  // also consider using the current string to help optimise the frequency detection
  var combinedStream = StreamZip<double>([
    frequencyStream,
    volumeStream,
  ]);

  return combinedStream.asyncMap((sample) async {
    var frequency = sample[0];
    var volume = sample[1];
    var threashold = ref.read(volumeThresholdProvider);

    return sample[0];
  });
}