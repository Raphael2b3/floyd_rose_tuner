import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/error_display.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_page.dart';
import 'package:floyd_rose_tuner/provider/guitars_provider.dart';
import 'package:floyd_rose_tuner/provider/calibration_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/guitar.dart';
import 'package:floyd_rose_tuner/types/calibration_state.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/types/tuning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class CalibrationPage extends ConsumerStatefulWidget {
  const CalibrationPage({super.key});

  @override
  ConsumerState<CalibrationPage> createState() =>
      _CalibrationPageState();
}

class _CalibrationPageState
    extends ConsumerState<CalibrationPage> {
  double calculateProgress(
    int effectingStringIndex,
    int sampleIndex,
    int stringIndex,
  ) {
    num v = effectingStringIndex * 12 + sampleIndex * 6 + stringIndex;
    return v / (5 * 12 + 1 * 12 + 6);
  }

  Future<void> applyMeasurement() async {
    CalibrationState calibrationState = ref.read(
      calibrationStateProvider,
    );
    CalibrationStateNotifier calibrationStateNotifier = ref
        .read(calibrationStateProvider.notifier);

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
    CalibrationState calibrationState = ref.watch(
      calibrationStateProvider,
    );
    int currentStringIndex = ref
        .watch(guitarStateMeasureStateProvider)
        .currentStringIndex;
    Guitar? selectedGuitar = ref
        .watch(selectedGuitarProvider)
        .value;

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
        Text("Measure Each String of Your Guitar", style: textTheme.titleLarge),
        Row(
          children: [
            Text(
              calibrationState.currentSampleIndex == 0
                  ? "Original: "
                  : "Change The String ",
            ),
            Chip(
              label: Text(
                tuning.goalNotes[calibrationState
                    .currentEffectingStringIndex],
              ),
            ),
            if (calibrationState.currentSampleIndex != 0)
              Text(" and Measure Again"),
          ],
        ),
        LinearProgressIndicator(
          year2023: false,
          value: (selectedGuitar.isValid
              ? 1
              : calculateProgress(
                  calibrationState.currentEffectingStringIndex,
                  calibrationState.currentSampleIndex,
                  currentStringIndex,
                )),
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
                context.router.navigate(const GuitarRoute());
              },
              child: Text("Change Name"),
            ),
            OutlinedButton(
              onPressed: () {
                context.router.push(const GuitarControlRoute());
              },
              child: Text("Check"),
            ),
            FilledButton(
              onPressed: selectedGuitar.isValid
                  ? () {
                      ref
                          .read(selectedGuitarProvider.notifier)
                          .calculateMatrix();
                      Guitar? guitar = ref
                          .read(selectedGuitarProvider)
                          .value;
                      if (guitar == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("No Guitar Selected!")),
                        );
                        return;
                      }
                      ref
                          .read(guitarsProvider.notifier)
                          .saveOverriding(guitar);

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
