import 'package:floyd_rose_tuner/types/guitar_state.dart';

class CalibrationState {
  final int currentEffectingStringIndex;

  final int currentSampleIndex;

  CalibrationState({
    required this.currentEffectingStringIndex,
    required this.currentSampleIndex,
    Map<int, List<GuitarState>>? guitarStateSamples,
  });

  CalibrationState copy({
    int? currentEffectingStringIndex,
    int? currentSampleIndex,
  }) {
    return CalibrationState(
      currentEffectingStringIndex:
          currentEffectingStringIndex ?? this.currentEffectingStringIndex,
      currentSampleIndex: currentSampleIndex ?? this.currentSampleIndex,
    );
  }
}
