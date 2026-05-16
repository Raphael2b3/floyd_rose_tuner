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

part 'guitar_tuning_assistant_provider.g.dart';

@Riverpod(keepAlive: true)
class GuitarTuningAssistantNotifier extends _$GuitarTuningAssistantNotifier {
  @override
  GuitarState build() {
    return GuitarState();
  }

  Future<void> calculateOrderedGoalNotes() async {
    DetuningMatrix? matrix = await ref.read(
      selectedDetuningMatrixProvider.future,
    );
    if (matrix == null) throw Exception("No selected Guitar");

    GuitarState guitarState = await ref.read(guitarStateProvider.future);

    TuningConfig tuning = await ref.watch(selectedTuningConfigProvider.future);
    Vector goalFrequencies = getFrequenciesFromGoalNotes(tuning.goalNotes);

    List<double> delta = floydRoseDeltaFrequencies(
      matrix.inverse,
      Vector.fromList(guitarState),
      goalFrequencies,
    );
    var predictedGoalFrequency = predictAbsolutGoalFrequencies(
      Vector.fromList(guitarState),
      Vector.fromList(delta),
      matrix.matrix,
    );
    state = GuitarState(values: predictedGoalFrequency);
  }
}
