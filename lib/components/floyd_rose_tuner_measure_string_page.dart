import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/error_display.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_view.dart';
import 'package:floyd_rose_tuner/provider/detected_frequency_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/tuning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class FloydRoseTunerMeasureStringPage extends ConsumerStatefulWidget {
  final bool cameBackFromError;

  const FloydRoseTunerMeasureStringPage({
    super.key,
    this.cameBackFromError = false,
  });

  @override
  ConsumerState<FloydRoseTunerMeasureStringPage> createState() =>
      _FloydRoseTunerMeasureStringPageState();
}

class _FloydRoseTunerMeasureStringPageState
    extends ConsumerState<FloydRoseTunerMeasureStringPage> {
  @override
  Widget build(BuildContext context) {
    var selectedString = ref
        .watch(guitarStateMeasureStateProvider)
        .currentStringIndex;

    Tuning? tuning = ref.watch(selectedTuningProvider).value;
    if (tuning == null) {
      return ErrorDisplay("Somehow No Tuning is Selected");
    }

    var textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Play", style: textTheme.titleLarge),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("String: ", style: textTheme.bodyLarge),
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
                if (selectedString == 0) {
                  // reverse x)
                  context.router.navigate(const FloydRoseTunerSetupRoute());
                  return;
                }
                if (selectedString > 0) {
                  //reverse b)
                  if (!widget.cameBackFromError) {
                    ref
                        .read(guitarStateMeasureStateProvider.notifier)
                        .selectPreviousString();
                  }
                  var lastFrequency = ref.read(
                    guitarStateProvider,
                  )[selectedString - 1];
                  context.router.navigate(
                    FloydRoseTunerCheckStringRoute(
                      detectedFrequency: lastFrequency.toDouble(),
                    ),
                  );
                  // we need to get the old detected Frequency
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
                  FloydRoseTunerCheckStringRoute(
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
