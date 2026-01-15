import 'dart:convert';

import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/utils/floyd_rose_delta_frequencies.dart';
import 'package:floyd_rose_tuner/utils/note_to_frequenzy.dart';
import 'package:ml_linalg/vector.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:statistics/statistics.dart';

import '../types/detuning_matrix.dart';

part 'guitar_tuning_assistant_provider.g.dart';

@Riverpod(keepAlive: true)
class GuitarTuningAssistantNotifier extends _$GuitarTuningAssistantNotifier {
  @override
  Future<List<double>> build() async {
    var matrix = await ref.watch(selectedDetuningMatrixProvider.future);
    if (matrix == null) return [];
    var guitarState = await ref.watch(guitarStateProvider.future);
    var tuning = await ref.watch(selectedTuningConfigProvider.future);
    var goalFrequencies = getFrequenciesFromGoalNotes(tuning.goalNotes);
    var delta = floydRoseDeltaFrequencies(
      matrix.inverse,
      Vector.fromList(guitarState),
      goalFrequencies,
    );
    return delta.asList;
  }
}
