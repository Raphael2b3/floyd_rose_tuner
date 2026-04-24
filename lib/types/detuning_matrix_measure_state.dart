import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/utils/multidimensional_orthogonal_regression.dart';

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

  void calculateMatrix() {
    var matrix = [];
    for (int i in guitarStateSamples.keys) {
      var samplesForEffectingString = guitarStateSamples[i]!;
      assert(samplesForEffectingString.length >= 2);
      var (m, c) =
          multiDimensionalOrthogonalRegression(samplesForEffectingString);

      matrix.add(m);
    }
  }
}
