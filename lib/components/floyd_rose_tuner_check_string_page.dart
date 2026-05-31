import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/error_display.dart';
import 'package:floyd_rose_tuner/provider/string_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/floyd_rose_tuning_assistant_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/guitar.dart';
import 'package:floyd_rose_tuner/types/tuning.dart';
import 'package:floyd_rose_tuner/utils/tone_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class FloydRoseTunerCheckStringPage extends ConsumerStatefulWidget {
  final double detectedFrequency;

  const FloydRoseTunerCheckStringPage({
    super.key,
    required this.detectedFrequency,
  });

  @override
  ConsumerState<FloydRoseTunerCheckStringPage> createState() =>
      _FloydRoseTunerCheckStringPageState();
}

class _FloydRoseTunerCheckStringPageState
    extends ConsumerState<FloydRoseTunerCheckStringPage> {
  @override
  Widget build(BuildContext context) {
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
              onPressed: () { // revers a)
                context.router.navigate(
                  FloydRoseTunerMeasureStringRoute(),
                );
              },
              child: Text("Back/No"),
            ),

            FilledButton(
              onPressed: () async {
                var gMeasureStateNotifier = ref.read(
                  stringMeasureStateProvider.notifier,
                );
                ref
                    .read(guitarStateProvider.notifier)
                    .saveFrequency(widget.detectedFrequency, currentString);
                if (currentString < 5) {
                  // b) see readme paper
                  gMeasureStateNotifier.selectNextString();
                  context.router.navigate(FloydRoseTunerMeasureStringRoute());
                } else { //c)
                  gMeasureStateNotifier.selectFirstString();
                  ref
                      .read(floydRoseTuningAssistantProvider.notifier)
                      .calculateOrderedGoalNotes();

                  context.router.navigate(FloydRoseTunerRoute());
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
