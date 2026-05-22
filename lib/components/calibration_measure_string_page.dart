import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/error_display.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_page.dart';
import 'package:floyd_rose_tuner/provider/calibration_state_provider.dart';
import 'package:floyd_rose_tuner/provider/detected_frequency_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/calibration_state.dart';
import 'package:floyd_rose_tuner/types/tuning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class CalibrationMeasureStringPage extends ConsumerStatefulWidget {
  const CalibrationMeasureStringPage({super.key});

  @override
  ConsumerState<CalibrationMeasureStringPage> createState() =>
      _CalibrationMeasureStringPageState();
}

class _CalibrationMeasureStringPageState
    extends ConsumerState<CalibrationMeasureStringPage> {
  @override
  Widget build(BuildContext context) {
    CalibrationState calibrationState = ref.watch(calibrationStateProvider);

    Tuning? tuning = ref.watch(selectedTuningProvider).value;
    if (tuning == null) {
      return ErrorDisplay("Somehow No Tuning is Selected");
    }

    var textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Play The String:", style: textTheme.titleLarge),
            Chip(
              label: Text(
                tuning.goalNotes[calibrationState.currentEffectingStringIndex],
                style: textTheme.titleLarge,
              ),
            ),
          ],
        ),

        GuitarStateMeasurePage(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                if (context.router.canNavigateBack) {
                  context.router.back();
                } else {
                  context.router.parent()?.back();
                }
              },
              child: Text("Back"),
            ),
            FilledButton(
              onPressed: () async {
                double detectedFrequency = await ref.read(
                  detectedFrequencyProvider.future,
                );
                ref.read(guitarStateMeasureStateProvider.notifier).selectNextString();
                context.router.navigate(
                  CalibrationCheckStringRoute(
                    detectedFrequency: detectedFrequency,
                  ),
                );
              },
              child: Text("Continue"),
            ),
          ],
        ),
      ],
    );
  }
}
