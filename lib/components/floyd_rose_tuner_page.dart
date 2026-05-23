import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/error_display.dart';
import 'package:floyd_rose_tuner/components/frequency_detector_view.dart';
import 'package:floyd_rose_tuner/provider/detected_frequency_provider.dart';
import 'package:floyd_rose_tuner/provider/string_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/floyd_rose_tuning_assistant_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/types/string_measure_state.dart';
import 'package:floyd_rose_tuner/utils/frequency_to_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

@RoutePage()
class FloydRoseTunerPage extends ConsumerWidget {
  const FloydRoseTunerPage({super.key});

  String hinText(num value) {
    switch (value) {
      case > 4:
        return "";
      case < -4:
        return "";
      default:
        return "Looks Good";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GuitarState floydRoseTuningAssistant = ref.watch(
      floydRoseTuningAssistantProvider,
    );
    var frequency = ref.watch(detectedFrequencyProvider).value;

    StringMeasureState stringMeasureState = ref.watch(
      stringMeasureStateProvider,
    );
    var tuning = ref.watch(selectedTuningProvider).value;
    if (tuning == null) return ErrorDisplay("No Tuning");
    if (frequency == null) return ErrorDisplay("Cannot detect Frequency");

    late num centDistance = getCentDistance(
      frequency,
      floydRoseTuningAssistant[stringMeasureState.currentStringIndex],
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Tune", style: Theme.of(context).textTheme.titleLarge),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("String: ", style: Theme.of(context).textTheme.bodyLarge),
            Chip(
              label: Text(
                tuning.goalNotes[stringMeasureState.currentStringIndex],
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        FrequencyDetectorView(),
        Stack(
          alignment: Alignment.center,
          children: [
            Slider(
              year2023: false,
              value: centDistance.clamp(-100.0, 100.0).toDouble(),
              max: 100,
              min: -100,
              activeColor: Theme.of(context).colorScheme.secondaryContainer,
              thumbColor: Theme.of(context).colorScheme.primary,
              onChanged: (_) {},
            ),
            IgnorePointer(
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  width: 24,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          hinText(centDistance),
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                if (stringMeasureState.currentStringIndex > 0) {
                  ref
                      .read(stringMeasureStateProvider.notifier)
                      .selectPreviousString();
                } else {
                  context.router.pop(const StandardTunerRoute());
                }
              },
              child: Text("Back"),
            ),
            FilledButton(
              onPressed: centDistance < 15 && centDistance > -15
                  ? () {
                      if (stringMeasureState.currentStringIndex < 5) {
                        ref
                            .read(stringMeasureStateProvider.notifier)
                            .selectNextString();
                      } else {
                        ref
                            .read(stringMeasureStateProvider.notifier)
                            .selectFirstString();
                        context.router.popUntilRoot();
                        context.router.root.navigate(
                          const StandardTunerRoute(),
                        );
                      }
                    }
                  : null,
              child: Text(
                stringMeasureState.currentStringIndex < 5
                    ? "Next"
                    : "Done",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
