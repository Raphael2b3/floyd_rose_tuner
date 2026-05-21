import 'package:floyd_rose_tuner/components/error_display.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/types/tuning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statistics/statistics.dart';

class GuitarStateView extends ConsumerWidget {
  final GuitarState guitarState;
  final int? selectedIndex;

  const GuitarStateView(this.guitarState, {super.key, this.selectedIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Tuning? tuning = ref.watch(selectedTuningProvider).value;
    if (tuning == null) return ErrorDisplay("No Tuning Selected");
    var guitarStateValidation = guitarState.validation;
    List<Widget> tiles = guitarState.indexed.map((e) {
      var (i, element) = e;
      var coreChild = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${tuning.goalNotes[i]}:"),
          Badge(
            isLabelVisible: !guitarStateValidation[i],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${element.toStringAsFixed(2)}"),
            ),
          ),
        ],
      );

      if (i == selectedIndex) {
        return Badge(
          label: Text("Recording"),
          offset: Offset.fromDirection(3.3, 43),
          child: FilledButton(
            style: FilledButton.styleFrom(padding: EdgeInsetsGeometry.all(8)),
            onPressed: () {},
            child: coreChild,
          ),
        );
      }
      return OutlinedButton(
        style: OutlinedButton.styleFrom(padding: EdgeInsetsGeometry.all(8)),
        onPressed: () {
          ref
                  .read(guitarStateMeasureStateProvider.notifier)
                  .currentStringIndex =
              i;
        },
        child: coreChild,
      );
    }).asList;

    return Card.outlined(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: tiles.sublist(0, 3),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: tiles.sublist(3),
            ),
          ],
        ),
      ),
    );
  }
}
