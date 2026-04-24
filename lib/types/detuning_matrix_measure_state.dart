import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/utils/calculate_matrix_column.dart';
import 'package:ml_linalg/matrix.dart';

class DetuningMatrixMeasureState {
  final int currentEffectingStringIndex;

  int get nextSampleNumber => guitarStateSamples.length;

  final int currentSampleIndex;

  final Map<int, List<GuitarState>> guitarStateSamples;

  DetuningMatrixMeasureState({
    required this.currentEffectingStringIndex,
    required this.currentSampleIndex,
    Map<int, List<GuitarState>>? guitarStateSamples,
  }) : guitarStateSamples =
           guitarStateSamples ??
           {
             0: [
               [0],
             ],
           };

  DetuningMatrixMeasureState copy({
    int? currentEffectingStringIndex,
    int? currentSampleIndex,
    Map<int, List<GuitarState>>? guitarStateSamples,
  }) {
    return DetuningMatrixMeasureState(
      currentEffectingStringIndex:
          currentEffectingStringIndex ?? this.currentEffectingStringIndex,
      currentSampleIndex: currentSampleIndex ?? this.currentSampleIndex,
      guitarStateSamples: guitarStateSamples ?? this.guitarStateSamples,
    );
  }
}
