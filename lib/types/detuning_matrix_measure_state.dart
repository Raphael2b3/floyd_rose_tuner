import 'package:floyd_rose_tuner/types/guitar_state.dart';

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

   List<GuitarState> get getCurrentSamples {
    var samples = guitarStateSamples[currentEffectingStringIndex];

    if (samples == null || samples.length < 2) {
      guitarStateSamples[currentEffectingStringIndex] = [
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0],
      ];
    }
    samples = guitarStateSamples[currentEffectingStringIndex];

    assert (currentSampleIndex < samples!.length && currentSampleIndex >= 0);

    return samples!;
  }
}
