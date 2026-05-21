import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/provider/tunings_provider.dart';
import 'package:floyd_rose_tuner/types/tuning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// We subclass ConsumerWidget instead of StatelessWidget
class TuningSelector extends ConsumerWidget {
  const TuningSelector({super.key});

  // "build" receives an extra parameter
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the AsyncValue safely; provide fallbacks for null
    final selectedAsync = ref.watch(selectedTuningProvider);
    Tuning? selected = selectedAsync.value;
    final configsAsync = ref.watch(tuningsProvider);
    final tunings = configsAsync.value ?? [];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownMenu(
          width: double.infinity,
          label: const Text("Tuning"),
          helperText: "e.g. Standard EADGBE",
          initialSelection: selected,
          dropdownMenuEntries: tunings
              .map((e) => DropdownMenuEntry<Tuning>(value: e, label: e.name))
              .toList(),
          onSelected: (Tuning? value) {
            if (value == null) return;
            ref.read(selectedTuningProvider.notifier).select(value);
          },
        ),
      ],
    );
  }
}
