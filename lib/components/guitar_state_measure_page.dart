import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/frequency_view.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_navigation.dart';
import 'package:floyd_rose_tuner/components/volume_threshold_selector.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/types/guitare_state_measure_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'frequency_detector_view.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

@RoutePage()
class GuitarStateMeasurePage extends ConsumerWidget {
  const GuitarStateMeasurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTuningConfig = ref.watch(selectedTuningConfigProvider).value;
    final selectedDetuningMatrix = ref
        .watch(selectedDetuningMatrixProvider)
        .value;
    if (selectedTuningConfig == null || selectedDetuningMatrix == null) {
      return Center(child: CircularProgressIndicator());
    }
    final int maxNumberOfStrings = selectedTuningConfig.goalNotes.length;
    var guitarStateMeasureState = ref.watch(guitarStateMeasureStateProvider);
    var currentStringIndex = guitarStateMeasureState.currentStringIndex;
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GuitarStateMeasureNavigation(),
          FrequencyView(),
          FrequencyDetectorView(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  if (currentStringIndex > 0) {
                    ref
                        .read(guitarStateMeasureStateProvider.notifier)
                        .set(
                          GuitarStateMeasureState(
                            currentStringIndex:
                                (currentStringIndex - 1) % maxNumberOfStrings,
                          ),
                        );
                  }
                },
                child: Text("Back"),
              ),
              if (currentStringIndex < maxNumberOfStrings)
                OutlinedButton(
                  onPressed: () {
                    if (currentStringIndex < maxNumberOfStrings) {
                      ref
                          .read(guitarStateMeasureStateProvider.notifier)
                          .set(
                            GuitarStateMeasureState(
                              currentStringIndex:
                                  (currentStringIndex + 1) % maxNumberOfStrings,
                            ),
                          );
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
