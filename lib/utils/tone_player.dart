import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';

class TonePlayer {
  static const int sampleRate = 44100;

  Future<void> playFrequency(
      double frequency, {
        double durationSeconds = 2.0,
        double volume = 0.5,
      }) async {
    final player = FlutterSoundPlayer();
    await player.openPlayer();

    final int totalSamples = (sampleRate * durationSeconds).toInt();
    final Uint8List bytes = Uint8List(totalSamples * 2);
    final ByteData byteData = ByteData.view(bytes.buffer);

    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double sample = sin(2 * pi * frequency * t);
      final int value = (sample * 32767 * volume).toInt();
      byteData.setInt16(i * 2, value, Endian.little);
    }

    await player.startPlayerFromStream(
      interleaved: true,
      codec: Codec.pcm16,
      sampleRate: sampleRate,
      numChannels: 1,
      bufferSize: 8192, // ✅ neu required in 9.x
    );

    await player.feedFromStream(bytes); // ✅ ersetzt foodSink?.add()

    await Future.delayed(
      Duration(milliseconds: (durationSeconds * 1000).toInt()),
    );

    await player.stopPlayer();
    await player.closePlayer();
  }
}