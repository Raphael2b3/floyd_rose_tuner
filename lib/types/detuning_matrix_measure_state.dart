class DetuningMatrixMeasureState {
  final int currentEffectingStringIndex;
  final int currentImpactedStringIndex;
  final List<num> guitarStateSamples = [];
  DetuningMatrixMeasureState({
    required this.currentEffectingStringIndex,
    required this.currentImpactedStringIndex,
  });

  DetuningMatrixMeasureState copy({
    int? currentEffectingStringIndex,
    int? currentImpactedStringIndex,
  }) {
    return DetuningMatrixMeasureState(
      currentEffectingStringIndex:
          currentEffectingStringIndex ?? this.currentImpactedStringIndex,
      currentImpactedStringIndex:
          currentImpactedStringIndex ?? this.currentImpactedStringIndex,
    );
  }
}
