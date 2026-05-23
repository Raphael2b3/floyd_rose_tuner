class StringMeasureState {
  final int currentStringIndex;
  final bool manualDetection;
  final List<bool> measuredStrings;

  StringMeasureState({
    required this.currentStringIndex,
    this.manualDetection = false,
    this.measuredStrings = const []
  });

  StringMeasureState copy({
    int? currentStringIndex,
    bool? manualDetection,
    List<bool>? measuredStrings
  }) {
    return StringMeasureState(
      currentStringIndex: currentStringIndex ?? this.currentStringIndex,
      manualDetection: manualDetection ?? this.manualDetection,
      measuredStrings: measuredStrings?? this.measuredStrings
    );
  }

  @override
  String toString() {
    return 'StringMeasureState(currentStringIndex: $currentStringIndex, manualDetection: $manualDetection)';
  }
}
