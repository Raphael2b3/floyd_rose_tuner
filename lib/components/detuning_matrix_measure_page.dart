import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/frequency_view.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_navigation.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:floyd_rose_tuner/types/guitare_state_measure_state.dart';
import 'package:floyd_rose_tuner/utils/random_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'frequency_detector_view.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

@RoutePage()
class DetuningMatrixMeasurePage extends ConsumerWidget {
  const DetuningMatrixMeasurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int maxNumberOfStrings = 6;
    List<List<num>> freshMatrix = [
      [1, 0, 0, 0, 0, 0],
      [0, 1, 0, 0, 0, 0],
      [0, 0, 1, 0, 0, 0],
      [0, 0, 0, 1, 0, 0],
      [0, 0, 0, 0, 1, 0],
      [0, 0, 0, 0, 0, 1],
    ];


    ref.read(selectedDetuningMatrixProvider.notifier).selectDetuningMatrix(
        DetuningMatrix(
            guitarName: "New Guitar ${random.nextInt(5555)}", matrix: freshMatrix));

    var guitarStateMeasureState = ref.watch(guitarStateMeasureStateProvider);
    var currentStringIndex = guitarStateMeasureState.currentStringIndex;
    return DefaultTabController(
      length: maxNumberOfStrings,
      initialIndex: currentStringIndex,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GuitarStateMeasureNavigation(),
          FrequencyView(),
          FrequencyDetectorView(),
          Builder(
            builder: (context2) =>
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        var index = ref
                            .read(guitarStateMeasureStateProvider.notifier)
                            .selectPreviousString();
                        DefaultTabController.of(context2).animateTo(index);
                      },
                      child: Text("Back"),
                    ),
                    FilledButton(
                      onPressed: () async {
                        ref
                            .read(guitarStateMeasureStateProvider.notifier)
                            .selectFirstString();
                        await context.router.push(const GuitarTuningRoute());
                      },
                      child: Text("Done"),
                    ),
                    if (currentStringIndex < maxNumberOfStrings - 1)
                      OutlinedButton(
                        onPressed: () {
                          var index = ref
                              .read(guitarStateMeasureStateProvider.notifier)
                              .selectNextString();
                          DefaultTabController.of(context2).animateTo(index);
                        },
                        child: Text("Next"),
                      ),
                  ],
                ),
          ),
        ],
      ),
    );
  }
}
