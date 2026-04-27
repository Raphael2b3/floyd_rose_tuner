import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/types/guitare_state_measure_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuitarStateMeasureNavigation extends ConsumerWidget {
  const GuitarStateMeasureNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedTuningConfig = ref.watch(selectedTuningConfigProvider);
    var selectedDetuningMatrix = ref.watch(selectedDetuningMatrixProvider);
    var guitarState = ref.watch(guitarStateProvider);

    if (selectedTuningConfig.value == null ||
        selectedDetuningMatrix.value == null) {
      return Text("Loading...");
    }
    // after the null-check above it's safe to assign to non-nullable locals
    final detuning = selectedDetuningMatrix.value;
    if (detuning == null) {
      return Text("No Detuning Matrix Selected");
    }
    final tuning = selectedTuningConfig.value;
    if (tuning == null) {
      return Text("No Tuning Config Selected");
    }
    final numberOfStrings = detuning.matrix.rowCount;
    assert(numberOfStrings == tuning.goalNotes.length);
    return TabBar(
      tabAlignment: TabAlignment.center,
      isScrollable: true,
      tabs: List.generate(numberOfStrings, (i) {
        var name = "String ${i + 1}";
        final guitarVals =
            guitarState.value ?? List<double>.filled(numberOfStrings, 1);
        var freq = guitarVals[i];
        return Tab(
          icon: Text(name),
          child: Text("${freq.toStringAsFixed(2)} Hz"),
        );
      }),
      onTap: (index) {
        print("Switching to string index $index");
        ref
            .read(guitarStateMeasureStateProvider.notifier)
            .set(
              GuitarStateMeasureState(
                currentStringIndex: index,
                manualDetection: ref
                    .read(guitarStateMeasureStateProvider)
                    .manualDetection,
              ),
            );
      },
    );
  }
}
