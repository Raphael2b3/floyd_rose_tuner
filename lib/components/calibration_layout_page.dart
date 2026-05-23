import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/provider/calibration_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/calibration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class CalibrationLayoutPage extends ConsumerWidget {
  const CalibrationLayoutPage({super.key});

  static const double maxProgress = (2 + 5 * 2 + 1 * 13 + 5 * 26);

  double calculateProgress(
    int pageId,
    int stringIndex,
    int sampleIndex,
    int effectingStringIndex,
  ) {
    num v =
        pageId + stringIndex * 2 + sampleIndex * 13 + effectingStringIndex * 26;
    return v / maxProgress;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CalibrationState calibrationState = ref.watch(calibrationStateProvider);
    int stringIndex = ref
        .watch(guitarStateMeasureStateProvider)
        .currentStringIndex;
    int effectingStringIndex = calibrationState.currentEffectingStringIndex;
    int sampleIndex = calibrationState.currentSampleIndex;

    return AutoRouter(
      builder: (context, content) {
        String? pageName = context.router.currentChild?.name;
        int pageIndex = pageName == CalibrationMeasureStringRoute.name
            ? 0
            : pageName == CalibrationChangeStringRoute.name
            ? 1
            : 2;
        var progress = calculateProgress(
          pageIndex,
          stringIndex,
          sampleIndex,
          effectingStringIndex,
        );
        return Column(
          children: [
            LinearProgressIndicator(year2023: false, value: (progress)),
            Text(
              //"$pageName "
              "${(progress * 100).toInt()}%",
            ),
            Expanded(child: content),
          ],
        );
      },
    );
  }
}
