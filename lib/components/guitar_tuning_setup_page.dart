import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/display_error.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_page.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/types/tuning_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

@RoutePage()
class GuitarTuningSetupPage extends ConsumerWidget {
  const GuitarTuningSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TuningConfig? selectedTuningConfig = ref
        .watch(selectedTuningConfigProvider)
        .value;

    DetuningMatrix? selectedDetuningMatrix = ref
        .watch(selectedDetuningMatrixProvider)
        .value;

    if (selectedTuningConfig == null || selectedDetuningMatrix == null) {
      return DisplayError(
        "selectedTuningConfig ($selectedTuningConfig) or selectedDetuningMatrix ($selectedDetuningMatrix) is null",
      );
    }

    // after the null-check above it's safe to assign to non-nullable locals
    final String guitarName = selectedDetuningMatrix.guitarName;

    GuitarState? guitarState = ref.watch(guitarStateProvider).value;
    if (guitarState == null) {
      return DisplayError("guitarState is null");
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "First Detect Your Guitars Strings",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            Text("Guitar: "),
            Chip(label: Text(guitarName)),
          ],
        ),
        Row(
          children: [
            Text("Tuning: "),
            Chip(label: Text(selectedTuningConfig.name)),
          ],
        ),

        GuitarStateMeasurePage(),

        FilledButton(
          onPressed: guitarState.isValid
              ? () {
                  context.router.push(const GuitarTuningRoute());
                }
              : null,
          child: Text("Tune The Guitar"),
        ),
      ],
    );
  }
}
