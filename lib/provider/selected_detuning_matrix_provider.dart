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
    List<DetuningMatrix> detuningMatrix = await ref.watch(
      detuningMatricesProvider.future,
    );
    if (detuningMatrix.isEmpty) {
      return null;
    }
    return detuningMatrix[0];
  }

  Future<void> selectDetuningMatrix(DetuningMatrix selected) async {
    state = AsyncValue.data(selected);
  }

  void deleteSample(int effectingStringIndex, int sampleIndex) {
    DetuningMatrix? detuningMatrix = state.value;
    if (detuningMatrix == null) {
      if (kDebugMode) {
        print("No detuning matrix selected, can't delete sample");
      }
      return;
    }
    List<GuitarState> currentSamples = detuningMatrix
        .getSamplesForEffectingString(effectingStringIndex);

    if (currentSamples.length < 3) {
      if (kDebugMode) {
        print("Can't delete sample, need at least 2 samples per string");
      }
      return;
    }

    detuningMatrix.samples[effectingStringIndex]?.removeAt(sampleIndex);
    ref.notifyListeners();
  }

  void addSampleForEffectingString(
    GuitarState guitarState,
    int effectingStringIndex,
  ) async {
    DetuningMatrix? detuningMatrix = state.value;
    if (detuningMatrix == null) {
      if (kDebugMode) {
        print("No detuning matrix selected, can't add sample");
      }
      return;
    }
    List<GuitarState>? innerSampleList = // TODO: Check if this is really by reference.
        detuningMatrix.samples[effectingStringIndex];
    if (innerSampleList == null) {
      detuningMatrix.samples[effectingStringIndex] = [guitarState];
    } else {
      innerSampleList.add(guitarState);
    }
    ref.notifyListeners();
  }

  void saveSamples(
    GuitarState guitarState,
    int effectingStringIndex,
    int sampleIndex,
  ) async {
    DetuningMatrix? detuningMatrix = state.value;

    if (detuningMatrix == null) {
      if (kDebugMode) {
        print("No detuning matrix selected, can't save sample");
      }
      return;
    }
    if (detuningMatrix.samples[effectingStringIndex] == null ||
        sampleIndex >= detuningMatrix.samples[effectingStringIndex]!.length ||
        sampleIndex < 0) {
      if (kDebugMode) {
        print(
          "Invalid sample index $sampleIndex for effecting string index $effectingStringIndex",
        );
      }
      return;
    }
    detuningMatrix.samples[effectingStringIndex]![sampleIndex] = guitarState;
    ref.notifyListeners();
  }

  void calculateMatrix() {
    DetuningMatrix? detuningMatrix = state.value;
    if (detuningMatrix == null) {
      if (kDebugMode) {
        print("No detuning matrix selected, can't calculate matrix");
      }
      return;
    }
    Map<int, List<GuitarState>> guitarStateSamples = detuningMatrix.samples;

    List<List<double>> matrix = [];
    for (int i in guitarStateSamples.keys) {
      List<GuitarState>? samplesForEffectingString = guitarStateSamples[i];
      if (samplesForEffectingString == null) {
        return print("samplesForEffectingString is null");
      }
      assert(samplesForEffectingString.length >= 2);
      List<double> column = calculateMatrixColumn(samplesForEffectingString, i);
      matrix.add(column);
    }
    Matrix matrixTransposed = Matrix.fromList(matrix).transpose();

    state = AsyncValue.data(detuningMatrix.copy(matrix: matrixTransposed));
    ref.notifyListeners();
  }
}
