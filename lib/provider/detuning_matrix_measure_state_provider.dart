import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix_measure_state.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'detuning_matrix_measure_state_provider.g.dart';

@riverpod
class DetuningMatrixMeasureStateNotifier
    extends _$DetuningMatrixMeasureStateNotifier {
  @override
  DetuningMatrixMeasureState build() {
    return DetuningMatrixMeasureState(
      currentEffectingStringIndex: 0,
      currentSampleIndex: 0,
    );
  }

  void set(DetuningMatrixMeasureState guitarMeasureState) {
    state = guitarMeasureState;
    ref.notifyListeners();
  }

  void deleteCurrentSample() {
    var currentSamples = state.getCurrentSamples;
    if (currentSamples.length < 3) {
      if (kDebugMode) {
        print("Can't delete sample, need at least 2 samples per string");
      }
      return;
    }
    if (state.currentSampleIndex >= currentSamples.length - 1) {
      state = state.copy(currentSampleIndex: currentSamples.length - 2);
    }
    state.guitarStateSamples[state.currentEffectingStringIndex]?.removeAt(
      state.currentSampleIndex,
    );
    ref.notifyListeners();
  }

  void addSampleForCurrentEffectingString() async {
    var guitarState = (await ref.read(guitarStateProvider.future));

    state.guitarStateSamples[state.currentEffectingStringIndex]?.add(
      guitarState,
    );
    state = state.copy(currentSampleIndex: state.getCurrentSamples.length - 1);
  }
}
