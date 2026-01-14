
import 'dart:typed_data';
import 'package:floyd_rose_tuner/utils/convert_rms_to_db_full_scale.dart';
import 'package:statistics/statistics.dart';

// Calculates the volume in dBFS from PCM16 encoded audio data
double pcm16todBFS(List<int> data) {
  double rms = data.standardDeviation;
  return convertRMSTodBFullScale(rms);
}