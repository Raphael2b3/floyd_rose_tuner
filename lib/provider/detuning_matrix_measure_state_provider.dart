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

  set currentEffectingStringIndex(int index) {
    state = state.copy(
      currentEffectingStringIndex: index,
      currentSampleIndex: 0,
    );

    ref.notifyListeners();
  }

  set currentSampleIndex(int index) {
    state = state.copy(currentSampleIndex: index);
    ref.notifyListeners();
  }
}
