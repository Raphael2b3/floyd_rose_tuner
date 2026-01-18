import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/frequency_view.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_navigation.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_tuning_assistant_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/types/guitare_state_measure_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'frequency_detector_view.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

@RoutePage()
class GuitarTuningPage extends ConsumerWidget {
  const GuitarTuningPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTuningConfig = ref.watch(selectedTuningConfigProvider).value;
    final guitarTuningAssistant = ref.watch(guitarTuningAssistantProvider);
    var selectedDetuningMatrix = ref
        .watch(selectedDetuningMatrixProvider)
        .value;

    if (selectedTuningConfig == null ||
        !guitarTuningAssistant.hasValue ||
        selectedDetuningMatrix == null) {
      return Center(child: CircularProgressIndicator());
    }
    final delta = guitarTuningAssistant.value!;

    final int maxNumberOfStrings = selectedTuningConfig.goalNotes.length;
    var guitarStateMeasureState = ref.watch(guitarStateMeasureStateProvider);
    var currentStringIndex = guitarStateMeasureState.currentStringIndex;

    // after the null-check above it's safe to assign to non-nullable locals
    final guitarName = selectedDetuningMatrix.guitarName;
    final numberOfStrings = delta.length;
    assert(numberOfStrings == selectedTuningConfig.goalNotes.length);

    var saveDelta = min(max(-100, delta[currentStringIndex]), 100);
    return DefaultTabController(
      length: maxNumberOfStrings,
      initialIndex: currentStringIndex,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("$guitarName - ${selectedTuningConfig.name}"),
          TabBar(
            tabAlignment: TabAlignment.center,
            isScrollable: true,
            tabs: List.generate(numberOfStrings, (i) {
              var name = selectedTuningConfig.goalNotes[i];
              var freq = delta[i];
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
          ),
          Slider(
            value: delta[currentStringIndex].clamp(-100, 100),
            min: -100,
            max: 100,
            onChanged: (value) {},
            year2023: false,
          ),
          FrequencyDetectorView(),
        ],
      ),
    );
  }
}
