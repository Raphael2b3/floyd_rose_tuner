
class CalibrationState {
  final int currentEffectingStringIndex;
  final int currentSampleIndex;
  CalibrationState({
    required this.currentEffectingStringIndex,
    required this.currentSampleIndex,
  });

  CalibrationState copy({
    int? currentEffectingStringIndex,
    int? currentSampleIndex,
    bool? stringIsChanging,
  }) {
    return CalibrationState(
      currentEffectingStringIndex:
          currentEffectingStringIndex ?? this.currentEffectingStringIndex,
      currentSampleIndex: currentSampleIndex ?? this.currentSampleIndex,
    );
  }
}
