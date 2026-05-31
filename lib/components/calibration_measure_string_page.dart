import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/error_display.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_view.dart';
import 'package:floyd_rose_tuner/provider/calibration_state_provider.dart';
import 'package:floyd_rose_tuner/provider/detected_frequency_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/provider/string_measure_state_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/tuning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class CalibrationMeasureStringPage extends ConsumerStatefulWidget {

  const CalibrationMeasureStringPage({
    super.key,
  });

  @override
  ConsumerState<CalibrationMeasureStringPage> createState() =>
      _CalibrationMeasureStringPageState();
}

class _CalibrationMeasureStringPageState
    extends ConsumerState<CalibrationMeasureStringPage> {
  @override
  Widget build(BuildContext context) {
    var selectedString = ref
        .watch(stringMeasureStateProvider)
        .currentStringIndex;

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
                tuning.goalNotes[selectedString],
                style: textTheme.titleLarge,
              ),
            ),
          ],
        ),

        GuitarStateMeasureView(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () async {
                var caliState = ref.read(calibrationStateProvider);
                if (selectedString == 0 && // reverse x)
                    caliState.currentSampleIndex == 0 &&
                    caliState.currentEffectingStringIndex == 0) {
                  context.router.parent()?.navigate(const GuitarRoute());
                  return;
                }
                if (selectedString > 0) {

                    ref
                        .read(stringMeasureStateProvider.notifier)
                        .selectPreviousString();


                  var lastFrequency =
                      (await ref.read(
                        selectedGuitarProvider.future,
                      ))!.getSamplesForEffectingString(
                        caliState.currentEffectingStringIndex,
                      )[caliState.currentSampleIndex][selectedString];
                  context.router.navigate(
                    CalibrationCheckStringRoute(
                      detectedFrequency: lastFrequency.toDouble(),
                    ),
                  );
                  // we need to get the old detected Frequency
                  return;
                }
                if (selectedString == 0 && caliState.currentSampleIndex > 0) {
                  //reverse e)
                  ref
                          .read(stringMeasureStateProvider.notifier)
                          .currentStringIndex =
                      5;
                  ref
                          .read(calibrationStateProvider.notifier)
                          .currentSampleIndex =
                      caliState.currentSampleIndex - 1;
                  context.router.navigate(const CalibrationChangeStringRoute());
                  return;
                }
                if (selectedString == 0 && //reverse f)
                    caliState.currentSampleIndex == 0 &&
                    caliState.currentEffectingStringIndex > 0) {
                  ref
                          .read(stringMeasureStateProvider.notifier)
                          .currentStringIndex =
                      5;
                  ref
                          .read(calibrationStateProvider.notifier)
                          .currentSampleIndex =  1;
                  context.router.navigate(const CalibrationChangeStringRoute());
                  return;
                }
              },
              child: Text("Back"),
            ),
            FilledButton(
              onPressed: () async {
                double detectedFrequency = await ref.read(
                  detectedFrequencyProvider.future,
                );
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
