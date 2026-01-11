import 'dart:math';
import 'dart:typed_data';
import 'package:floyd_rose_tuner/utils/convert_rms_to_db_full_scale.dart';
import 'package:statistics/statistics.dart';

Int16List bytesToInt16List(Uint8List data) {
  var normal_data = data.asByteData();
  assert(data.lengthInBytes % 2 == 0);
  Int16List output = Int16List(data.length ~/ 2);
  for (int i = 0; i < data.lengthInBytes; i += 2) {
    // Little-endian
    int sample = normal_data.getInt16(i, Endian.little);
    output[i ~/ 2] = sample; // Process the sample as needed
  }
  return output;
}
