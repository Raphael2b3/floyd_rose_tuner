import 'dart:math';
import 'dart:typed_data';

import 'package:floyd_rose_tuner/provider/audio_stream_provider.dart';
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'volume_stream_provider.g.dart';



double calculateVolume(Uint8List data) {

  if (data.isEmpty) return -20.0; // sehr leise (Silence)

  // Root Mean Square (RMS) berechnen

  var list = data.buffer.asInt16List();

  double sumSquares = 0;
  for (final sample in list) {
    sumSquares += sample*sample;
  }
  double rms = sqrt(sumSquares / data.length);

  // Umrechnung in Dezibel (dBFS, max = 32768)
  double db = 20 * log(rms / 32768) / ln10;

  return db.isFinite ? max(-20,db) : -20.0;
}

@riverpod
Future<Stream<double>> volumeStream(Ref ref) async {
  var stream = await ref.watch(audioStreamProvider.future);
  return stream!.asyncMap((sample) async {
    return calculateVolume(sample);
  });
}