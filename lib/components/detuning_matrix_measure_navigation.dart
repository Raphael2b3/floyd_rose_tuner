import 'package:floyd_rose_tuner/provider/detuning_matrix_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix_measure_state.dart';
import 'package:floyd_rose_tuner/types/guitare_state_measure_state.dart';
import 'package:floyd_rose_tuner/utils/frequency_to_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DetuningMatrixMeasureNavigation extends ConsumerWidget {
  const DetuningMatrixMeasureNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedDetuningMatrix = ref.watch(selectedDetuningMatrixProvider);
    var detuningMatrixMeasureState = ref.watch(detuningMatrixMeasureStateProvider);
    if (selectedDetuningMatrix.value == null) {
      return Text("Loading...");
    }
    // after the null-check above it's safe to assign to non-nullable locals
    final detuning = selectedDetuningMatrix.value!;
    final numberOfStrings = detuning.matrix.rowCount;
    return Column(
      children: [
        Text(
          "${detuning.guitarName} - ${getNoteName(detuningMatrixMeasureState.currentEffectingStringIndex)} Sample ${detuningMatrixMeasureState.sampleNumber}",
        ),
        TabBar(
          tabAlignment: TabAlignment.center,
          isScrollable: true,
          tabs: List.generate(numberOfStrings, (i) {
            var name = tuning.goalNotes[i];
            final guitarVals = detuningMatrixMeasureState.value ?? List<double>.filled(numberOfStrings, 1);
            var freq = guitarVals[i];
            return Tab(
              icon: Text(name),
              child: Text("${freq.toStringAsFixed(2)} Hz"),
            );
          }),
          onTap: (index) {
            print("Switching to string index $index");
            ref.read(detuningMatrixMeasureStateMeasureStateProvider.notifier).set(
                DetuningMatrixMeasureState(currentImpactedStringIndex: 0, currentEffectingStringIndex: 0);
          },
        ),
      ],
    );
  }
}
