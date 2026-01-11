import 'dart:typed_data';

extension PCMConversions on Int16List {
  List<double> convertPCM16ToNormalizedFloat() {
    return map((sample) => sample / 32768.0).toList();
  }
}
