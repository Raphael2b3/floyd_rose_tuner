import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/error_display.dart';
import 'package:floyd_rose_tuner/provider/calibration_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/calibration_state.dart';
import 'package:floyd_rose_tuner/types/guitar.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
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
  double calculateProgress(
    int effectingStringIndex,
    int sampleIndex,
    int stringIndex,
  ) {
    num v = effectingStringIndex * 12 + sampleIndex * 6 + stringIndex;
    return v / (5 * 12 + 1 * 12 + 6);
  }

  Future<void> applyMeasurement() async {
    CalibrationState calibrationState = ref.read(calibrationStateProvider);
    CalibrationStateNotifier calibrationStateNotifier = ref.read(
      calibrationStateProvider.notifier,
    );

    SelectedGuitarNotifier selectedGuitarNotifier = ref.read(
      selectedGuitarProvider.notifier,
    );
    GuitarState guitarState = (await ref.read(
      guitarStateProvider.future,
    )).copy(); // copy because otherwise the reference will be the same

    int currentEffectingStringIndex =
        calibrationState.currentEffectingStringIndex;
    int currentSampleIndex = calibrationState.currentSampleIndex;

    if (!guitarState.isValid) {
      var i = guitarState.validation.indexOf(false);
      ref.read(guitarStateMeasureStateProvider.notifier).currentStringIndex = i;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Measure Every String"),
            showCloseIcon: true,
          ),
        );
      }
      return;
    }
    await selectedGuitarNotifier.saveSamples(
      guitarState,
      currentEffectingStringIndex,
      currentSampleIndex,
    );

    var nextSampleIndex = (currentSampleIndex + 1) % 2;

    if (nextSampleIndex == 0) {
      var nextEffectingStringIndex = (currentEffectingStringIndex + 1) % 6;
      calibrationStateNotifier.currentEffectingStringIndex =
          nextEffectingStringIndex;

      if (nextEffectingStringIndex != 0) {
        await selectedGuitarNotifier.saveSamples(
          guitarState,
          nextEffectingStringIndex,
          nextSampleIndex,
        );
        nextSampleIndex++;
      }
    }
    calibrationStateNotifier.currentSampleIndex = nextSampleIndex;
    ref.read(guitarStateMeasureStateProvider.notifier).currentStringIndex = 0;
    ref.read(guitarStateProvider.notifier).guitarState = GuitarState();
  }

  @override
  Widget build(BuildContext context) {
    CalibrationState calibrationState = ref.watch(calibrationStateProvider);
    int currentStringIndex = ref
        .watch(guitarStateMeasureStateProvider)
        .currentStringIndex;
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
            tuning.goalNotes[calibrationState.currentEffectingStringIndex],
            style: textTheme.titleLarge,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                context.router.back();
              },
              child: Text("Back"),
            ),

            FilledButton(
              onPressed: () {
                context.navigateTo(const CalibrationMeasureStringRoute());
              },
              child: Text("Done"),
            ),
          ],
        ),
      ],
    );
  }
}
