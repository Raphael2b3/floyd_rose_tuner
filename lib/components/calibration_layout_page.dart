import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/error_display.dart';
import 'package:floyd_rose_tuner/provider/calibration_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/types/calibration_state.dart';
import 'package:floyd_rose_tuner/types/guitar.dart';
import 'package:floyd_rose_tuner/types/tuning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class CalibrationLayoutPage extends ConsumerWidget {
  const CalibrationLayoutPage({super.key});

  static const double maxProgress = (5 * 24 + 1 * 12 + 5 * 2 + 1);

  double calculateProgress(
    int effectingStringIndex,
    int sampleIndex,
    int stringIndex,
    bool bla,
  ) {
    num v =
        effectingStringIndex * 24 +
        sampleIndex * 12 +
        stringIndex  +
        (bla ? 6 : 0);
    return v / maxProgress;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    var progress = calculateProgress(
      calibrationState.currentEffectingStringIndex,
      calibrationState.currentSampleIndex,
      currentStringIndex,
      calibrationState.stringIsChanging,
    );
    return SizedBox.expand(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              LinearProgressIndicator(
                year2023: false,
                value: (selectedGuitar.isValid
                    ? 1
                    : progress),
              ),
              Text("${(progress*maxProgress).toInt()}/${maxProgress.toInt()}"),
              Expanded(child: AutoRouter()),
            ],
          ),
        ),
      ),
    );
  }
}
