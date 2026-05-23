import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/error_display.dart';
import 'package:floyd_rose_tuner/provider/calibration_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/calibration_state.dart';
import 'package:floyd_rose_tuner/types/guitar.dart';
import 'package:floyd_rose_tuner/types/tuning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class CalibrationChangeStringPage extends ConsumerStatefulWidget {
  const CalibrationChangeStringPage({super.key});

  @override
  ConsumerState<CalibrationChangeStringPage> createState() =>
      _CalibrationPageChangeStringState();
}

class _CalibrationPageChangeStringState
    extends ConsumerState<CalibrationChangeStringPage> {
  @override
  Widget build(BuildContext context) {
    CalibrationState calibrationState = ref.watch(calibrationStateProvider);
    int effectingString = calibrationState.currentEffectingStringIndex;
    int sampleIndex = calibrationState.currentSampleIndex;
    Guitar? selectedGuitar = ref.watch(selectedGuitarProvider).value;

    Tuning? tuning = ref.watch(selectedTuningProvider).value;
    if (selectedGuitar == null || tuning == null) {
      return ErrorDisplay(
        "Somehow No Guitar is Selected"
        "Somehow No Tuning is Selected",
      );
    }

    var textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Change the String", style: textTheme.titleLarge),
        Chip(
          label: Text(
            tuning.goalNotes[effectingString],
            style: textTheme.titleLarge,
          ),
        ),
        OutlinedButton(
          onPressed: () {
            var caliNotifier = ref.read(calibrationStateProvider.notifier);
            caliNotifier.currentSampleIndex = 0;
            ref
                .read(guitarStateMeasureStateProvider.notifier)
                .selectFirstString();
            context.navigateTo(CalibrationMeasureStringRoute());
          },
          child: Text("Wrong String Changed :("),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () async {
                var stringIndex = ref
                    .read(guitarStateMeasureStateProvider)
                    .currentStringIndex;

                //reverse d)
                var caliNotifier = ref.read(calibrationStateProvider.notifier);
                caliNotifier.currentSampleIndex = 0;
                ref
                    .read(guitarStateMeasureStateProvider.notifier)
                    .selectFirstString();

                var lastFrequency =
                    (await ref.read(
                      selectedGuitarProvider.future,
                    ))!.getSamplesForEffectingString(
                      calibrationState.currentEffectingStringIndex,
                    )[calibrationState.currentSampleIndex][stringIndex];
                if (sampleIndex == 1 && effectingString > 0) {
                  caliNotifier.currentEffectingStringIndex =
                      effectingString - 1;
                }
                context.router.navigate(
                  CalibrationCheckStringRoute(
                    detectedFrequency: lastFrequency.toDouble(),
                  ),
                );
              },
              child: Text("Back"),
            ),

            FilledButton(
              onPressed: () {
                var caliNotifier = ref.read(calibrationStateProvider.notifier);
                caliNotifier.currentSampleIndex = sampleIndex + 1;
                ref
                    .read(guitarStateMeasureStateProvider.notifier)
                    .selectFirstString();
                context.navigateTo(CalibrationMeasureStringRoute());
              },
              child: Text("Done"),
            ),
          ],
        ),

      ],
    );
  }
}
