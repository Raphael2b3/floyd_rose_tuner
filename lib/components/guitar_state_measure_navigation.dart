import 'dart:math';

import 'package:floyd_rose_tuner/provider/frequency_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/provider/volume_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/volume_threshold_provider.dart';
import 'package:floyd_rose_tuner/utils/frequency_to_note.dart';
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
    final numberOfStrings = selectedDetuningMatrix.value!.matrix.length;
    assert(numberOfStrings == selectedTuningConfig.value!.goalNotes.length);
    return Column(
      children: [
        Text(
          "${selectedDetuningMatrix.value?.guitarName ?? ""} - ${selectedTuningConfig.value?.name ?? ""}",
        ),
        DefaultTabController(
          length: numberOfStrings,
          child: TabBar(
            tabAlignment: TabAlignment.center,
            isScrollable: true,
            tabs: List.generate(numberOfStrings, (i) {
              var name = selectedTuningConfig.value?.goalNotes[i] ?? "N/A";
              var freq = guitarState.value![i];
              return Column(
                children: [
                  Tab(
                    icon: Text(name),
                    child: Text("${freq.toStringAsFixed(2)} Hz"),
                  ),
                ],
              );
            }),
            onTap: (index) {},
          ),
        ),
      ],
    );
  }
}
