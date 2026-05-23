import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/error_display.dart';
import 'package:floyd_rose_tuner/provider/calibration_state_provider.dart';
import 'package:floyd_rose_tuner/provider/string_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitars_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/calibration_state.dart';
import 'package:floyd_rose_tuner/types/guitar.dart';
import 'package:floyd_rose_tuner/types/tuning.dart';
import 'package:floyd_rose_tuner/utils/tone_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class CalibrationCheckStringPage extends ConsumerStatefulWidget {
  double detectedFrequency = 0;

  CalibrationCheckStringPage({super.key, required this.detectedFrequency});

  @override
  ConsumerState<CalibrationCheckStringPage> createState() =>
      _CalibrationCheckStringPageState();
}

class _CalibrationCheckStringPageState
    extends ConsumerState<CalibrationCheckStringPage> {
  @override
  Widget build(BuildContext context) {
    CalibrationState calibrationState = ref.watch(calibrationStateProvider);
    int effectingString = calibrationState.currentEffectingStringIndex;
    int sampleIndex = calibrationState.currentSampleIndex;
    int currentString = ref
        .watch(stringMeasureStateProvider)
        .currentStringIndex;
    Tuning? tuning = ref.watch(selectedTuningProvider).value;
    if (tuning == null) {
      return ErrorDisplay(
        "Somehow No Guitar is Selected\n"
        "Somehow No Tuning is Selected\n"
        "GuitarState is Null\n",
      );
    }
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Double Check", style: textTheme.titleLarge),
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("String:", style: textTheme.titleMedium),

            Chip(
              label: Text(
                tuning.goalNotes[currentString],
                style: textTheme.titleLarge,
              ),
            ),
          ],
        ),
        Text(
          "Does the Sound Match the Note you Just Played?",
          style: textTheme.bodyLarge,
        ),
        TextButton.icon(
          onPressed: () async {
            await TonePlayer().playFrequency(widget.detectedFrequency);
          },

          icon: Icon(Icons.volume_up, size: 50),
          label: Text(
            "Play Sound\n(${widget.detectedFrequency.toStringAsFixed(2)} Hz)",
            style: textTheme.titleLarge,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                context.router.navigate(
                  CalibrationMeasureStringRoute(cameBackFromError: true),
                );
              },
              child: Text("Back/No"),
            ),

            FilledButton(
              onPressed: () async {
                var gMeasureStateNotifier = ref.read(
                  stringMeasureStateProvider.notifier,
                );
                var selectedGuitarNotifier = ref.read(
                  selectedGuitarProvider.notifier,
                );

                selectedGuitarNotifier.setStringMeasurement(
                  widget.detectedFrequency,
                  effectingString,
                  sampleIndex,
                  currentString,
                );
                if (currentString < 5) {
                  // b) see readme paper
                  gMeasureStateNotifier.selectNextString();
                  context.router.navigate(CalibrationMeasureStringRoute());
                } else if (sampleIndex < 1) {
                  //d) see readme paper
                  gMeasureStateNotifier.currentStringIndex = effectingString;
                  context.router.navigate(const CalibrationChangeStringRoute());
                } else if (effectingString < 5) {
                  //g) see readme paper
                  gMeasureStateNotifier.currentStringIndex =
                      effectingString + 1;
                  ref.read(calibrationStateProvider.notifier)
                    ..currentEffectingStringIndex = effectingString + 1
                    ..currentSampleIndex = 0;
                  var oldSamples = ref
                      .read(selectedGuitarProvider)
                      .value
                      ?.getSamplesForEffectingString(
                        effectingString,
                      )[sampleIndex];
                  selectedGuitarNotifier.saveSamples(
                    oldSamples!.copy(),
                    effectingString + 1,
                    0,
                  );

                  context.router.navigate(CalibrationChangeStringRoute());
                } else {
                  selectedGuitarNotifier.calculateMatrix();

                  Guitar? guitar = ref.read(selectedGuitarProvider).value;
                  if (guitar == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No Guitar Selected!")),
                    );
                    return;
                  }
                  await ref
                      .read(guitarsProvider.notifier)
                      .saveOverriding(guitar);
                  context.router.navigate(CalibrationControlRoute());
                }
              },
              child: Text("Yes"),
            ),
          ],
        ),
      ],
    );
  }
}
