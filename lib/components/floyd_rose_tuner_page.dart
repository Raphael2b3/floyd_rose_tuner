import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/error_display.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_tuning_assistant_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/types/guitar_state_measure_state.dart';
import 'package:floyd_rose_tuner/utils/frequency_to_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

@RoutePage()
class FloydRoseTunerPage extends ConsumerWidget {
  const FloydRoseTunerPage({super.key});

  String hinText(num value) {
    switch (value) {
      case > 1:
        return "To LOW! Tune the String higher";
      case < -1:
        return "To HIGH! Tune the String lower";
      default:
        return "Looks Good";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GuitarState guitarTuningAssistant = ref.watch(
      guitarTuningAssistantProvider,
    );
    GuitarState? guitarState = ref.watch(guitarStateProvider).value;
    GuitarStateMeasureState guitarStateMeasureState = ref.watch(
      guitarStateMeasureStateProvider,
    );
    var tuning = ref.watch(selectedTuningProvider).value;
    if (tuning == null) return ErrorDisplay("No Tuning");
    if (guitarState == null) return ErrorDisplay("guitarState is null");

    num frequency = guitarState[guitarStateMeasureState.currentStringIndex];

    late num centDistance = getCentDistance(
      frequency,
      guitarTuningAssistant[guitarStateMeasureState.currentStringIndex],
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Tune Your String", style: Theme.of(context).textTheme.titleLarge),
        Row(
          children: [
            Text("We Are Tuning: "),
            Chip(
              label: Text(
                tuning.goalNotes[guitarStateMeasureState
                    .currentStringIndex],
              ),
            ),
          ],
        ),
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
          hinText(
            guitarTuningAssistant[guitarStateMeasureState.currentStringIndex],
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                if (guitarStateMeasureState.currentStringIndex > 0) {
                  ref
                      .read(guitarStateMeasureStateProvider.notifier)
                      .selectPreviousString();
                } else {
                  context.router.pop(const StandardTunerRoute());
                }
              },
              child: Text("Back"),
            ),
            FilledButton(
              onPressed: centDistance < 4 && centDistance > -4
                  ? () {
                      if (guitarStateMeasureState.currentStringIndex < 5) {
                        ref
                            .read(guitarStateMeasureStateProvider.notifier)
                            .selectNextString();
                      } else {
                        context.router.popUntilRouteWithName(
                          FloydRoseTunerSetupRoute.name,
                        );
                        context.router.root.navigate(
                          const StandardTunerRoute(),
                        );
                      }
                    }
                  : null,
              child: Text(
                guitarStateMeasureState.currentStringIndex < 5
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
