import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/utils/calculate_matrix_column.dart';
import 'package:flutter/foundation.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  void deleteSample(int effectingStringIndex, int sampleIndex) {
    if (state.value == null) {
      if (kDebugMode) {
        print("No detuning matrix selected, can't delete sample");
      }
      return;
    }
    var currentSamples = state.value?.getSamplesForEffectingString(
      effectingStringIndex,
    );

    if (currentSamples == null) {
      if (kDebugMode) {
        print(
          "No samples found for effecting string index $effectingStringIndex, can't delete sample",
        );
      }
      return;
    }
    if (currentSamples.length < 3) {
      if (kDebugMode) {
        print("Can't delete sample, need at least 2 samples per string");
      }
      return;
    }

    state.value?.samples[effectingStringIndex]?.removeAt(sampleIndex);
    ref.notifyListeners();
  }

  void addSampleForEffectingString(
    GuitarState guitarState,
    int effectingStringIndex,
  ) async {
    if (state.value == null) {
      if (kDebugMode) {
        print("No detuning matrix selected, can't add sample");
      }
      return;
    }
    state.value?.samples[effectingStringIndex]?.add(guitarState);

    ref.notifyListeners();
  }

  void saveSamples(
    GuitarState guitarState,
    int effectingStringIndex,
    int sampleIndex,
  ) async {
    if (state.value == null) {
      if (kDebugMode) {
        print("No detuning matrix selected, can't save sample");
      }
      return;
    }
    if (state.value?.samples[effectingStringIndex] == null ||
        sampleIndex >= state.value!.samples[effectingStringIndex]!.length ||
        sampleIndex < 0) {
      if (kDebugMode) {
        print(
          "Invalid sample index $sampleIndex for effecting string index $effectingStringIndex",
        );
      }
      return;
    }
    state.value?.samples[effectingStringIndex]![sampleIndex] = guitarState;
    ref.notifyListeners();
  }

  void calculateMatrix() {
    if (state.value == null) {
      if (kDebugMode) {
        print("No detuning matrix selected, can't calculate matrix");
      }
      return;
    }
    var guitarStateSamples = state.value!.samples;

    List<List<double>> matrix = [];
    for (int i in guitarStateSamples.keys) {
      var samplesForEffectingString = guitarStateSamples[i];
      if (samplesForEffectingString == null) {
        return print("samplesForEffectingString is null");
      }
      assert(samplesForEffectingString.length >= 2);
      var column = calculateMatrixColumn(samplesForEffectingString, i);
      matrix.add(column);
    }
    var matrixTransposed = Matrix.fromList(matrix).transpose();

    state = AsyncValue.data(state.value!.copy(matrix: matrixTransposed));
    ref.notifyListeners();
  }
}
