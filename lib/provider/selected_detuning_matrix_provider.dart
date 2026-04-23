import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'detuning_matrix_measure_state_provider.dart';

part 'selected_detuning_matrix_provider.g.dart';

@riverpod
class SelectedDetuningMatrixNotifier extends _$SelectedDetuningMatrixNotifier {
  @override
  Future<DetuningMatrix?> build() async {
    var detuningMatrix = await ref.watch(detuningMatricesProvider.future);
    if (detuningMatrix.isEmpty) {
      return null;
    }
    return detuningMatrix[0];
  }

  Future<void> selectDetuningMatrix(DetuningMatrix selected) async {
    state = AsyncValue.data(selected);
  }

  void deleteCurrentSample() {
    var detuningMatrixMeasureState = ref.read(
      detuningMatrixMeasureStateProvider,
    );
    int currentEffectingStringIndex =
        detuningMatrixMeasureState.currentEffectingStringIndex;
    int currentSampleIndex = detuningMatrixMeasureState.currentSampleIndex;

    var currentSamples = state.value?.getSamplesForEffectingString(
      currentEffectingStringIndex,
    );

    if (currentSamples!.length < 3) {
      if (kDebugMode) {
        print("Can't delete sample, need at least 2 samples per string");
      }
      return;
    }
    if (currentSampleIndex >= currentSamples.length - 1) {
      ref
          .read(detuningMatrixMeasureStateProvider.notifier)
          .set(
            detuningMatrixMeasureState.copy(
              currentSampleIndex: currentSamples.length - 2,
            ),
          );
    }

    state.value?.samples[currentEffectingStringIndex]?.removeAt(
      currentSampleIndex,
    );
    ref.notifyListeners();
  }

  void addSampleForCurrentEffectingString() async {
    var guitarState = (await ref.read(guitarStateProvider.future));
    var detuningMatrixMeasureState = ref.read(
      detuningMatrixMeasureStateProvider,
    );

    state.value!.samples[detuningMatrixMeasureState.currentEffectingStringIndex]
        ?.add(guitarState);
    /*ref
        .read(detuningMatrixMeasureStateProvider.notifier)
        .set(
      detuningMatrixMeasureState.copy(
        currentSampleIndex: currentSamples.length - 2,
      ),
    );*/
    // TODO switch to the new sample after adding
    ref.notifyListeners();
  }
}
