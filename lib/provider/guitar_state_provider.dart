import 'package:floyd_rose_tuner/provider/detected_frequency_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:ml_linalg/vector.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'guitar_state_measure_state_provider.dart';

part 'guitar_state_provider.g.dart';

@Riverpod(keepAlive: true)
class GuitarStateNotifier extends _$GuitarStateNotifier {
  List<num> guitarState = [0,0,0,0,0,0];

  @override
  Future<GuitarState> build() async {
    final guitarStateMeasureState = ref.read(guitarStateMeasureStateProvider);
    final detectedFrequency = await ref.watch(detectedFrequencyProvider.future);
    // ensure a list exists for this guitar
    final index = guitarStateMeasureState.currentStringIndex;
    if (index >= 0 && index < guitarState.length) {
      guitarState[index] = detectedFrequency;
    }
    return guitarState;
  }
}
