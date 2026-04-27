import 'dart:typed_data';
import 'package:statistics/statistics.dart';

Int16List bytesToInt16List(Uint8List data) {
  ByteData normalData = data.asByteData();
  assert(data.lengthInBytes % 2 == 0);
  Int16List output = Int16List(data.length ~/ 2);
  for (int i = 0; i < data.lengthInBytes; i += 2) {
    // Little-endian
    int sample = normalData.getInt16(i, Endian.little);
    output[i ~/ 2] = sample; // Process the sample as needed
  }
  return output;
}
