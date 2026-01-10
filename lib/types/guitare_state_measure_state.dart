class GuitarStateMeasureState {
  final int currentStringIndex;
  final bool manualDetection;

  GuitarStateMeasureState({
    required this.currentStringIndex,
    this.manualDetection = false,
  });

  GuitarStateMeasureState copy({
    int? currentStringIndex,
    bool? manualDetection,
  }) {
    return GuitarStateMeasureState(
      currentStringIndex: currentStringIndex ?? this.currentStringIndex,
      manualDetection: manualDetection ?? this.manualDetection,
    );
  }

  @override
  String toString() {
    return 'GuitarStateMeasureState(currentStringIndex: $currentStringIndex, manualDetection: $manualDetection)';
  }
}
