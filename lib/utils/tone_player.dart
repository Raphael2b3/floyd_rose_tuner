import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';

class TonePlayer {
  static const int sampleRate = 44100;

  double fadeOut(double duration, int index) {
    int maxLength = (sampleRate * duration).toInt();
    int fadeOutPositionIndex = (maxLength * 0.9).toInt();

    // Abstand vom Start des Fade-Outs bis zum echten Ende des Audios
    int distance = maxLength - fadeOutPositionIndex;

    if (index >= maxLength) {
      return 0.0; // Audio ist vorbei
    } else if (index >= fadeOutPositionIndex) {
      int currentDistance = index - fadeOutPositionIndex;
      // Sinkt linear von 1.0 auf 0.0
      return 1.0 - (currentDistance / distance);
    } else {
      return 1.0; // Volle Lautstärke vor dem Fade-Out
    }
  }

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
      final double sample =
          sin(2 * pi * frequency * t) + 1 / 2 * sin(4 * pi * frequency * t);
      final int value = (sample * 32767 * volume * fadeOut(durationSeconds, i))
          .toInt();
      byteData.setInt16(i * 2, value, Endian.little);
    }

    await player.startPlayerFromStream(
      interleaved: true,
      codec: Codec.pcm16,
      sampleRate: sampleRate,
      numChannels: 1,
      bufferSize: 8192, // ✅ neu required in 9.x
    );

    await player.feedUint8FromStream(bytes); // ✅ ersetzt foodSink?.add()

    await Future.delayed(
      Duration(milliseconds: (durationSeconds * 1000).toInt()),
    );

    await player.stopPlayer();
    await player.closePlayer();
  }
}
