import 'package:floyd_rose_tuner/provider/detected_frequency_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:ml_linalg/vector.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'guitar_state_measure_state_provider.dart';

part 'guitar_state_provider.g.dart';

@Riverpod(keepAlive: true)
class GuitarStateNotifier extends _$GuitarStateNotifier {
  Map<String, List<num>> guitarStates = {};

  @override
  Future<GuitarState> build() async {
    final guitarStateMeasureState = ref.watch(guitarStateMeasureStateProvider);

    final currentDetuningMatrix = await ref.watch(
      selectedDetuningMatrixProvider.future,
    );

    if (currentDetuningMatrix == null) {
      // no detuning matrix selected -> return a default guitar state
      return List.generate(6, (i) => 1);
    }

    final name = currentDetuningMatrix.guitarName;
    List<num> currentGuitarState = getGuitarStateSave(name);

    final detectedFrequency = await ref.watch(detectedFrequencyProvider.future);
    // ensure a list exists for this guitar
    final index = guitarStateMeasureState.currentStringIndex;
    if (index >= 0 && index < currentGuitarState.length) {
      currentGuitarState[index] = detectedFrequency;
    }
    return currentGuitarState;
  }

  GuitarState getGuitarStateSave(String name, [int length = 6]) {
    return guitarStates.putIfAbsent(
      name,
      () => List.generate(length, (i) => 1),
    );
  }

  void setGuitarState(double frequency) {
    final currentDetuningMatrix = ref
        .read(selectedDetuningMatrixProvider)
        .value;
    if (currentDetuningMatrix == null) {
      return;
    }
    final name = currentDetuningMatrix.guitarName;
    var currentGuitarState = getGuitarStateSave(name);

    final guitarStateMeasureState = ref.read(guitarStateMeasureStateProvider);
    final index = guitarStateMeasureState.currentStringIndex;
    if (index >= 0 && index < currentGuitarState.length) {
      currentGuitarState[index] = frequency;
      guitarStates[name] = currentGuitarState;
      ref.notifyListeners();
    }
  }
}
