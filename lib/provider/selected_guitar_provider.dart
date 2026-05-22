import 'package:floyd_rose_tuner/provider/calibration_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitars_provider.dart';
import 'package:floyd_rose_tuner/types/guitar.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/utils/calculate_matrix_row.dart';
import 'package:flutter/foundation.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_guitar_provider.g.dart';

@riverpod
class SelectedGuitarNotifier extends _$SelectedGuitarNotifier {
  @override
  Future<Guitar?> build() async {
    List<Guitar> guitar = await ref.read(guitarsProvider.future);
    if (guitar.isEmpty) {
      return null;
    }
    return guitar[0];
  }

  void select(Guitar? selected) {
    state = AsyncValue.data(selected);
  }

  Future<void> selectAny() async {
    state = AsyncValue.data(await build()); // TODO codeSmell could have sideeffects
  }

  void deleteSample(int effectingStringIndex, int sampleIndex) {
    Guitar? guitar = state.value;
    if (guitar == null) {
      if (kDebugMode) {
        print("No detuning matrix selected, can't delete sample");
      }
      return;
    }
    List<GuitarState> currentSamples = guitar.getSamplesForEffectingString(
      effectingStringIndex,
    );

    if (currentSamples.length < 3) {
      if (kDebugMode) {
        print("Can't delete sample, need at least 2 samples per string");
      }
      return;
    }

    guitar.samples[effectingStringIndex]?.removeAt(sampleIndex);
    ref.read(calibrationStateProvider.notifier).currentSampleIndex =
        sampleIndex % (currentSamples.length - 1);
    ref.notifyListeners();
  }

  Future<void> addSampleForEffectingString(
    GuitarState guitarState,
    int effectingStringIndex,
  ) async {
    Guitar? guitar = state.value;
    if (guitar == null) {
      if (kDebugMode) {
        print("No detuning matrix selected, can't add sample");
      }
      return;
    }
    List<GuitarState>?
    innerSampleList = // TODO: Check if this is really by reference.
        guitar.samples[effectingStringIndex];
    if (innerSampleList == null) {
      guitar.samples[effectingStringIndex] = [guitarState];
    } else {
      innerSampleList.add(guitarState);
    }
    ref.notifyListeners();
  }

  Future<void> saveSamples(
    GuitarState guitarState,
    int effectingStringIndex,
    int sampleIndex,
  ) async {
    Guitar? guitar = state.value;

    if (guitar == null) {
      if (kDebugMode) {
        print("No detuning matrix selected, can't save sample");
      }
      return;
    }
    if (guitar.samples[effectingStringIndex] == null ||
        sampleIndex >= guitar.samples[effectingStringIndex]!.length ||
        sampleIndex < 0) {
      if (kDebugMode) {
        print(
          "Invalid sample index $sampleIndex for effecting string index $effectingStringIndex",
        );
      }
      return;
    }
    guitar.samples[effectingStringIndex]![sampleIndex] = guitarState;
    ref.notifyListeners();
  }

  void calculateMatrix() {
    Guitar? guitar = state.value;
    if (guitar == null) {
      if (kDebugMode) {
        print("No detuning matrix selected, can't calculate matrix");
      }
      return;
    }
    Map<int, List<GuitarState>> guitarStateSamples = guitar.samples;
    guitarStateSamples.forEach((key, value) => print("$key : $value"));
    List<List<double>> matrix = [];
    for (int i in guitarStateSamples.keys) {
      List<GuitarState>? samplesForEffectingString = guitarStateSamples[i];
      if (samplesForEffectingString == null) {
        return print("samplesForEffectingString is null");
      }
      assert(samplesForEffectingString.length >= 2);
      List<double> row = calculateMatrixRow(samplesForEffectingString, i);
      matrix.add(row);
    }
    Matrix matrixTransposed = Matrix.fromList(matrix).transpose();

    state = AsyncValue.data(guitar.copy(matrix: matrixTransposed));
    ref.notifyListeners();
  }
}
