import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/types/guitare_state_measure_state.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'guitar_state_measure_state_provider.g.dart';

@riverpod
class GuitarStateMeasureStateNotifier
    extends _$GuitarStateMeasureStateNotifier {
  @override
  GuitarStateMeasureState build() {
   return GuitarStateMeasureState(
      currentStringIndex: 0,
      manualDetection: false,
    );
  }

  void set(GuitarStateMeasureState guitarMeasureState) {
    print("Setting guitar measure state to $guitarMeasureState");
    var matrixLength = ref
        .read(selectedDetuningMatrixProvider)
        .value
        ?.matrix
        .length;
    print("Detuning matrix length: $matrixLength");
    var selectedTuningConfigLength = ref
        .read(selectedTuningConfigProvider)
        .value
        ?.goalNotes
        .length;
    print("Tuning config length: $selectedTuningConfigLength");
    if (matrixLength == null || selectedTuningConfigLength == null) {
      print("Matrix length or tuning config length is null, cannot set guitar measure state");
      return;
    }
    assert(matrixLength == selectedTuningConfigLength);
    print("Validated matrix length and tuning config length are equal: $matrixLength");
    if (guitarMeasureState.currentStringIndex < 0 ||
        guitarMeasureState.currentStringIndex >= matrixLength) {
      throw Exception(
        "Invalid string index ${guitarMeasureState.currentStringIndex} for guitar with $matrixLength strings",
      );
    }
    state = guitarMeasureState.copy();
    ref.notifyListeners();
    print("Guitar measure state set to $guitarMeasureState");
  }
}
