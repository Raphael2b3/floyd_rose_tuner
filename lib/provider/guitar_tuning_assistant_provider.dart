import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/types/guitar.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/types/tuning.dart';
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
    Guitar? matrix = await ref.read(
      selectedGuitarProvider.future,
    );
    if (matrix == null) throw Exception("No selected Guitar");

    GuitarState guitarState = await ref.read(guitarStateProvider.future);

    Tuning tuning = await ref.watch(selectedTuningProvider.future);
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
