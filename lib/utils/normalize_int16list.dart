extension PCMConversions on List<int> {
  List<double> normalizeInt16List() {
    return map((sample) => sample / 32768.0).toList();
  }
}
