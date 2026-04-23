import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix_measure_state.dart';
import 'package:floyd_rose_tuner/types/guitare_state_measure_state.dart';
import 'package:flutter/rendering.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'detuning_matrix_measure_state_provider.g.dart';

@riverpod
class DetuningMatrixMeasureStateNotifier
    extends _$DetuningMatrixMeasureStateNotifier {
  @override
  DetuningMatrixMeasureState build() {
    return DetuningMatrixMeasureState(
      currentEffectingStringIndex: 0,
      currentSampleIndex: 0
    );
  }

  void set(DetuningMatrixMeasureState guitarMeasureState) {
    //TODO implement learning the detuning matrix with good UX
  }

  int selectNextString() {
    return 0;
  }

  int selectPreviousString() {
    return 0;
  }

  void selectFirstString() {

  }
}
