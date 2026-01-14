import 'package:floyd_rose_tuner/provider/audio_stream_provider.dart';
import 'package:floyd_rose_tuner/utils/pcm16_to_dBFS.dart';
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import "package:statistics/statistics.dart";

part 'volume_stream_provider.g.dart';

@riverpod
Future<Stream<double>> volumeStream(Ref ref) async {
  var stream = await ref.watch(audioStreamProvider.future);
  return stream!.asyncMap((sample) async {
    print("median value ${sample.median}");
    return pcm16todBFS(sample);
  });
}
