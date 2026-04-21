import 'package:floyd_rose_tuner/types/guitar_state.dart';

class DetuningMatrixMeasureState {
  final int currentEffectingStringIndex;

  int get sampleNumber => guitarStateSamples.length;

  final Map<int, List<GuitarState>> guitarStateSamples;

  DetuningMatrixMeasureState({
    required this.currentEffectingStringIndex,
    Map<int, List<GuitarState>>? guitarStateSamples,
  }) : guitarStateSamples =
           guitarStateSamples ?? {} as Map<int, List<GuitarState>>;

  DetuningMatrixMeasureState copy({
    int? currentEffectingStringIndex,
    int? currentImpactedStringIndex,
    Map<int, List<GuitarState>>? guitarStateSamples,
  }) {
    return DetuningMatrixMeasureState(
      currentEffectingStringIndex:
          currentEffectingStringIndex ?? this.currentEffectingStringIndex,
      guitarStateSamples: guitarStateSamples ?? this.guitarStateSamples,
    );
  }
}
