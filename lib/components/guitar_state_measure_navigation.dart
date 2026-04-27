import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/types/guitare_state_measure_state.dart';
import 'package:floyd_rose_tuner/types/tuning_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuitarStateMeasureNavigation extends ConsumerWidget {
  const GuitarStateMeasureNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TuningConfig? selectedTuningConfig = ref.watch(selectedTuningConfigProvider).value;
    DetuningMatrix? selectedDetuningMatrix = ref
        .watch(selectedDetuningMatrixProvider)
        .value;
    GuitarState? guitarState = ref.watch(guitarStateProvider).value;

    if (selectedTuningConfig == null ||
        selectedDetuningMatrix == null ||
        guitarState == null) {
      return Text("Loading...");
    }

    return TabBar(
      tabAlignment: TabAlignment.center,
      isScrollable: true,
      tabs: List.generate(guitarState.length, (i) {
        String name = "String ${i + 1}";
        String freq = guitarState[i].toStringAsFixed(2);
        return Tab(icon: Text(name), child: Text("$freq Hz"));
      }),
      onTap: (index) {
        print("Switching to string index $index");
        ref
            .read(guitarStateMeasureStateProvider.notifier)
            .guitarStateMeasureState = GuitarStateMeasureState(
          currentStringIndex: index,
          manualDetection: ref
              .read(guitarStateMeasureStateProvider)
              .manualDetection,
        );
      },
    );
  }
}
