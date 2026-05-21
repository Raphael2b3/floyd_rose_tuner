class GuitarStateMeasureState {
  final int currentStringIndex;
  final bool manualDetection;
  final List<bool> measuredStrings;

  GuitarStateMeasureState({
    required this.currentStringIndex,
    this.manualDetection = false,
    this.measuredStrings = const []
  });

  GuitarStateMeasureState copy({
    int? currentStringIndex,
    bool? manualDetection,
    List<bool>? measuredStrings
  }) {
    return GuitarStateMeasureState(
      currentStringIndex: currentStringIndex ?? this.currentStringIndex,
      manualDetection: manualDetection ?? this.manualDetection,
      measuredStrings: measuredStrings?? this.measuredStrings
    );
  }

  @override
  String toString() {
    return 'GuitarStateMeasureState(currentStringIndex: $currentStringIndex, manualDetection: $manualDetection)';
  }
}
