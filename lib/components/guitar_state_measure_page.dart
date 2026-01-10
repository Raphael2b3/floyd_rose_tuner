import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/frequency_view.dart';
import 'package:floyd_rose_tuner/components/volume_threshold_selector.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'frequency_detector_view.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

@RoutePage()
class GuitarStateMeasurePage extends ConsumerStatefulWidget {
  const GuitarStateMeasurePage({super.key});

  @override
  ConsumerState<GuitarStateMeasurePage> createState() =>
      _GuitarStateMeasurePageState();
}

class _GuitarStateMeasurePageState
    extends ConsumerState<GuitarStateMeasurePage> {
  int currentStringIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedTuningConfig = ref.watch(selectedTuningConfigProvider).value;
    final selectedDetuningMatrix = ref
        .watch(selectedDetuningMatrixProvider)
        .value;
    if (selectedTuningConfig == null || selectedDetuningMatrix == null) {
      return Center(child: CircularProgressIndicator());
    }
    final int maxNumberOfStrings = selectedTuningConfig.goalNotes.length;

    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            selectedDetuningMatrix.guitarName,
            style: TextStyle(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Measure your"),
              Text(
                selectedTuningConfig.goalNotes[currentStringIndex],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("String"),
            ],
          ),
          FrequencyView(),
          FrequencyDetectorView(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  if (currentStringIndex > 0) {
                    setState(() {
                      currentStringIndex--;
                    });
                  } else {
                    context.router.pop();
                  }
                },
                child: Text("Back"),
              ),
              if (currentStringIndex < maxNumberOfStrings)
                OutlinedButton(
                  onPressed: () {
                    if (currentStringIndex < maxNumberOfStrings) {
                      setState(() {
                        currentStringIndex =
                            (currentStringIndex + 1) % maxNumberOfStrings;
                      });
                    }
                  },
                  child: Text("Next"),
                )
              else
                FilledButton(
                  onPressed: () {
                    context.router.maybePop([1, 2, 3]);
                  },
                  child: Text("Done"),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
