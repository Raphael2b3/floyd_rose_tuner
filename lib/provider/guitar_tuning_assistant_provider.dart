import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/types/tuning_config.dart';
import 'package:floyd_rose_tuner/utils/floyd_rose_delta_frequencies.dart';
import 'package:floyd_rose_tuner/utils/note_to_frequenzy.dart';
import 'package:ml_linalg/vector.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:statistics/statistics.dart';

part 'guitar_tuning_assistant_provider.g.dart';

@Riverpod(keepAlive: true)
class GuitarTuningAssistantNotifier extends _$GuitarTuningAssistantNotifier {
  @override
  Future<GuitarState> build() async {
    DetuningMatrix? matrix = await ref.watch(selectedDetuningMatrixProvider.future);
    print("got matrix");
    if (matrix == null) return GuitarState();
    GuitarState guitarState = await ref.watch(guitarStateProvider.future);
    print("got guitarstate");
    TuningConfig tuning = await ref.watch(selectedTuningConfigProvider.future);
    print("got tuning");
    Vector goalFrequencies = getFrequenciesFromGoalNotes(tuning.goalNotes);
    print("got goalFrequencies");
    List<double> delta = floydRoseDeltaFrequencies(
      matrix.inverse,
      Vector.fromList(guitarState),
      goalFrequencies,
    );
    print("delta ${delta.asList}");
    return GuitarState(values: delta);
  }
}
