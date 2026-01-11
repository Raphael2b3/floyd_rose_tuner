
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:floyd_rose_tuner/utils/convert_rms_to_db_full_scale.dart';
import 'package:floyd_rose_tuner/utils/pcm16_encoding_to_Int16List.dart';
import 'package:statistics/statistics.dart';

// Calculates the volume in dBFS from PCM16 encoded audio data
double pcm16todBFS(Int16List data) {
  print("Mean ${data.mean}");
  double rms = data.standardDeviation;
  print("rms $rms");
  return convertRMSTodBFullScale(rms);
}