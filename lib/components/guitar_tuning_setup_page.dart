import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/error_display.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_page.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_tuning_assistant_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/guitar.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/types/tuning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

@RoutePage()
class GuitarTuningSetupPage extends ConsumerWidget {
  const GuitarTuningSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Tuning? selectedTuning = ref
        .watch(selectedTuningProvider)
        .value;

    Guitar? selectedGuitar = ref
        .watch(selectedGuitarProvider)
        .value;

    if (selectedTuning == null || selectedGuitar == null) {
      return ErrorDisplay(
        "selectedTuning ($selectedTuning) or selectedGuitar ($selectedGuitar) is null",
      );
    }

    // after the null-check above it's safe to assign to non-nullable locals
    final String guitarName = selectedGuitar.guitarName;

    GuitarState? guitarState = ref.watch(guitarStateProvider).value;
    if (guitarState == null) {
      return ErrorDisplay("guitarState is null");
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "First Detect Your Guitars Strings",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            Text("Guitar: "),
            Chip(label: Text(guitarName)),
          ],
        ),
        Row(
          children: [
            Text("Tuning: "),
            Chip(label: Text(selectedTuning.name)),
          ],
        ),

        GuitarStateMeasurePage(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              child: Text("Back"),
              onPressed: () {
                context.router.pop();
              },
            ),
            FilledButton(
              onPressed: guitarState.isValid
                  ? () {
                      ref
                              .read(guitarStateMeasureStateProvider.notifier)
                              .currentStringIndex =
                          0;
                      ref
                          .read(guitarTuningAssistantProvider.notifier)
                          .calculateOrderedGoalNotes();
                      context.router.navigate(const FloydRoseTuningRoute());
                    }
                  : null,
              child: Text("Tune The Guitar"),
            ),
          ],
        ),
      ],
    );
  }
}
