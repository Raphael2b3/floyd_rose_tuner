import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/display_error.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_page.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrix_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix_measure_state.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/types/tuning_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class DetuningMatrixMeasurePage extends ConsumerStatefulWidget {
  const DetuningMatrixMeasurePage({super.key});

  @override
  ConsumerState<DetuningMatrixMeasurePage> createState() =>
      _DetuningMatrixMeasureStatePageState();
}

class _DetuningMatrixMeasureStatePageState
    extends ConsumerState<DetuningMatrixMeasurePage> {
  Future<void> applyMeasurement() async {
    DetuningMatrixMeasureState detuningMatrixMeasureState = ref.read(
      detuningMatrixMeasureStateProvider,
    );
    SelectedDetuningMatrixNotifier selectedDetuningMatrixNotifier = ref.read(
      selectedDetuningMatrixProvider.notifier,
    );
    DetuningMatrixMeasureStateNotifier detuningMatrixMeasureStateNotifier = ref
        .read(detuningMatrixMeasureStateProvider.notifier);

    int currentEffectingStringIndex =
        detuningMatrixMeasureState.currentEffectingStringIndex;
    int currentSampleIndex = detuningMatrixMeasureState.currentSampleIndex;

    GuitarState guitarState = (await ref.read(
      guitarStateProvider.future,
    )).copy(); // copy because otherwise the reference will be the same
    if (!guitarState.isValid) {
      var i = guitarState.validation.indexOf(false);
      ref.read(guitarStateMeasureStateProvider.notifier).currentStringIndex = i;
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Please Measure Every String")));
      }
      return;
    }
    await selectedDetuningMatrixNotifier.saveSamples(
      guitarState,
      currentEffectingStringIndex,
      currentSampleIndex,
    );

    var nextSampleIndex = (currentSampleIndex + 1) % 2;

    if (nextSampleIndex == 0) {
      var nextEffectingStringIndex = (currentEffectingStringIndex + 1) % 6;
      detuningMatrixMeasureStateNotifier.currentEffectingStringIndex =
          nextEffectingStringIndex;

      if (nextEffectingStringIndex != 0) {
        await selectedDetuningMatrixNotifier.saveSamples(
          guitarState,
          nextEffectingStringIndex,
          nextSampleIndex,
        );
        nextSampleIndex++;
      }
    }
    detuningMatrixMeasureStateNotifier.currentSampleIndex = nextSampleIndex;
    ref.read(guitarStateMeasureStateProvider.notifier).currentStringIndex = 0;
    ref.read(guitarStateProvider.notifier).guitarState = GuitarState();
  }

  @override
  Widget build(BuildContext context) {
    DetuningMatrixMeasureState detuningMatrixMeasureState = ref.watch(
      detuningMatrixMeasureStateProvider,
    );
    DetuningMatrix? selectedDetuningMatrix = ref
        .watch(selectedDetuningMatrixProvider)
        .value;

    TuningConfig? tuningConfig = ref.watch(selectedTuningConfigProvider).value;
    if (selectedDetuningMatrix == null || tuningConfig == null) {
      return DisplayError(
        "Somehow No Guitar is Selected"
        "Somehow No Tuning is Selected",
      );
    }

    var textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Measure Each String of Your Guitar", style: textTheme.titleLarge),
        Row(
          children: [
            Text(
              detuningMatrixMeasureState.currentSampleIndex == 0
                  ? "Original: "
                  : "Change The String: ",
            ),
            Chip(
              label: Text(
                tuningConfig.goalNotes[detuningMatrixMeasureState
                    .currentEffectingStringIndex],
              ),
            ),
          ],
        ),
        GuitarStateMeasurePage(),
        FilledButton.icon(
          onPressed: applyMeasurement,
          label: Text("Save & Next"),
          icon: Icon(Icons.camera_alt_outlined),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                if (context.router.stack.length > 1) {
                  var pageBefore =
                      context.router.stack[context.router.stack.length - 2];
                  if (pageBefore.name == DetuningMatrixNamingRoute.name) {
                    return context.router.back();
                  }
                }
                context.router.push(const DetuningMatrixNamingRoute());
              },
              child: Text("Change Name"),
            ),
            OutlinedButton(
              onPressed: () {
                context.router.push(const DetuningMatrixControlRoute());
              },
              child: Text("Check"),
            ),
            FilledButton(
              onPressed: selectedDetuningMatrix.isValid
                  ? () {
                      ref
                          .read(selectedDetuningMatrixProvider.notifier)
                          .calculateMatrix();
                      DetuningMatrix? detuningMatrix = ref
                          .read(selectedDetuningMatrixProvider)
                          .value;
                      if (detuningMatrix == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("No Guitar Selected!")),
                        );
                        return;
                      }
                      ref
                          .read(detuningMatricesProvider.notifier)
                          .saveDetuningMatrixOverriding(detuningMatrix);

                      context.router.popUntilRouteWithName(
                        FloydRoseTunerSetupRoute.name,
                      );
                    }
                  : null,
              child: Text("Done"),
            ),
          ],
        ),
      ],
    );
  }
}
