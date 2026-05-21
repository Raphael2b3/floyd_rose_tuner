import 'package:floyd_rose_tuner/components/guitar_state_view.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/types/guitar.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/types/guitar_state_measure_state.dart';
import 'package:floyd_rose_tuner/types/tuning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuitarStateMeasureNavigation extends ConsumerWidget {
  const GuitarStateMeasureNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Tuning? selectedTuning = ref
        .watch(selectedTuningProvider)
        .value;
    Guitar? selectedGuitar = ref
        .watch(selectedGuitarProvider)
        .value;
    GuitarState? guitarState = ref.watch(guitarStateProvider).value;

    if (selectedTuning == null ||
        selectedGuitar == null ||
        guitarState == null) {
      return Text("Loading...");
    }
    var selectedString = ref
        .watch(guitarStateMeasureStateProvider)
        .currentStringIndex;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Press to Start Recording String"),
        GuitarStateView(guitarState, selectedIndex: selectedString),
      ],
    );

  }
}
