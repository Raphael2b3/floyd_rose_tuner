import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_tuning_assistant_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
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
    DetuningMatrix? selectedDetuningMatrix = ref
        .watch(selectedDetuningMatrixProvider)
        .value;

    if (selectedTuningConfig == null ||
        !guitarTuningAssistant.hasValue ||
        selectedDetuningMatrix == null) {
      return Center(
        child: Column(
          children: [
            Text(
              "selectedTuningConfig ($selectedTuningConfig) or guitarTuningAssistant ($guitarTuningAssistant) or selectedDetuningMatrix ($selectedDetuningMatrix) is null",
            ),
            CircularProgressIndicator(),
          ],
        ),
      );
    }
    final delta = guitarTuningAssistant.value;
    if (delta == null) {
      return Center(
        child: Column(
          children: [Text("delta is null"), CircularProgressIndicator()],
        ),
      );
    }

    final int maxNumberOfStrings = selectedTuningConfig.goalNotes.length;
    GuitarStateMeasureState guitarStateMeasureState = ref.watch(
      guitarStateMeasureStateProvider,
    );
    int currentStringIndex = guitarStateMeasureState.currentStringIndex;

    // after the null-check above it's safe to assign to non-nullable locals
    final guitarName = selectedDetuningMatrix.guitarName;
    final numberOfStrings = delta.length;
    assert(numberOfStrings == selectedTuningConfig.goalNotes.length);
    late String hintText;

    switch (delta[currentStringIndex]) {
      case > 4:
        hintText = "To LOW! Tune the String higher";
      case < -4:
        hintText = "To HIGH! Tune the String lower";
      default:
        hintText = "Looks Good";
    }
    GuitarState? guitarState = ref.watch(guitarStateProvider).value;
    if (guitarState == null) {
      return Center(
        child: Column(
          children: [Text("guitarState is null"), CircularProgressIndicator()],
        ),
      );
    }
    return DefaultTabController(
      length: maxNumberOfStrings,
      initialIndex: currentStringIndex,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("$guitarName - ${selectedTuningConfig.name}"),
          Text(
            guitarState.map((element) => element.toStringAsFixed(2)).join("|"),
          ),
          TabBar(
            tabAlignment: TabAlignment.center,
            isScrollable: true,
            tabs: List.generate(numberOfStrings, (i) {
              String name = selectedTuningConfig.goalNotes[i];
              num freq = delta[i];
              return Tab(
                icon: Text(name),
                child: Text("${freq.toStringAsFixed(2)} Hz"),
              );
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
          ),
          Text(
            hintText,
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
          Text(
            "Offset ${(-delta[currentStringIndex]).toStringAsFixed(2)} Hz",
            style: TextStyle(fontSize: 20),
          ),
          FrequencyDetectorView(),
          OutlinedButton(
            onPressed: () {
              context.router.pop();
            },
            child: Text("Done"),
          ),
        ],
      ),
    );
  }
}
