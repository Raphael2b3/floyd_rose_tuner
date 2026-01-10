import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/provider/tuning_configs_provider.dart';
import 'package:flutter/material.dart';
import 'package:floyd_rose_tuner/types/tuning_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// We subclass ConsumerWidget instead of StatelessWidget
class TuningConfigSelector extends ConsumerWidget {
  // "build" receives an extra parameter
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the AsyncValue safely; provide fallbacks for null
    final selectedAsync = ref.watch(selectedTuningConfigProvider);
    final selected = selectedAsync.value;
    final configsAsync = ref.watch(tuningConfigsProvider);
    final tuningConfigs = configsAsync.value ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownMenu(
          label: const Text("Tuning Config"),
          helperText: "e.g. Standard EADGBE",
          initialSelection: selected,
          dropdownMenuEntries: tuningConfigs
              .map((e) => DropdownMenuEntry<TuningConfig>(value: e, label: e.name))
              .toList(),
          onSelected: (TuningConfig? value) {
            if (value == null) return;
            ref.read(selectedTuningConfigProvider.notifier).selectTuningConfig(value);
          },
        ),
      ],
    );
  }
}
