import 'package:floyd_rose_tuner/types/guitar_state.dart';

class DetuningMatrixMeasureState {
  final int currentEffectingStringIndex;

  final int currentSampleIndex;

  DetuningMatrixMeasureState({
    required this.currentEffectingStringIndex,
    required this.currentSampleIndex,
    Map<int, List<GuitarState>>? guitarStateSamples,
  });

  DetuningMatrixMeasureState copy({
    int? currentEffectingStringIndex,
    int? currentSampleIndex,
  }) {
    return DetuningMatrixMeasureState(
      currentEffectingStringIndex:
          currentEffectingStringIndex ?? this.currentEffectingStringIndex,
      currentSampleIndex: currentSampleIndex ?? this.currentSampleIndex,
    );
  }
}
