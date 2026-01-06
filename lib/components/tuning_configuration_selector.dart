import 'package:flutter/material.dart';
import 'package:floyd_rose_tuner/types/tuning_configuration.dart';

class TuningConfigurationSelector extends StatefulWidget {
  /// A selector that does NOT use Riverpod. Provide the current selection
  /// and an [onChanged] callback. If [defaultList] or [customList] are omitted
  /// a built-in default list will be used.
  const TuningConfigurationSelector({super.key, this.goal = 0.5, required this.current, this.defaultList, this.customList, this.onChanged});

  final double goal;
  final TuningConfiguration current;
  final List<TuningConfiguration>? defaultList;
  final List<TuningConfiguration>? customList;
  final ValueChanged<TuningConfiguration>? onChanged;

  @override
  State<TuningConfigurationSelector> createState() => _TuningConfigurationSelectorState();
}

class _TuningConfigurationSelectorState extends State<TuningConfigurationSelector> {
  late List<TuningConfiguration> _defaultList;

  @override
  void initState() {
    super.initState();
    _defaultList = widget.defaultList ?? [
      TuningConfiguration(name: 'Standard E', goalNotes: ["E2", "A2", "D3", "G3", "B3", "E4"]),
      TuningConfiguration(name: 'Drop D', goalNotes: ["D2", "A2", "D3", "G3", "B3", "E4"]),
      TuningConfiguration(name: 'DADGAD', goalNotes: ["D2", "A2", "D3", "G3", "A3", "D4"]),
      TuningConfiguration(name: 'Open G', goalNotes: ["D2", "G2", "D3", "G3", "B3", "D4"]),
      TuningConfiguration(name: 'Half Step Down', goalNotes: ["Eb2", "Ab2", "Db3", "Gb3", "Bb3", "Eb4"]),
      TuningConfiguration(name: 'Whole Step Down', goalNotes: ["D2", "G2", "C3", "F3", "A3", "D4"]),
      TuningConfiguration(name: 'Drop C', goalNotes: ["C2", "G2", "C3", "F3", "A3", "D4"]),
      TuningConfiguration(name: 'Drop B', goalNotes: ["B1", "Gb2", "B2", "E3", "Ab3", "Db4"]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final customList = widget.customList ?? [];
    final all = [..._defaultList, ...customList];

    // initial selection name
    final initialName = widget.current.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownMenu(
          label: const Text("Tuning Configuration"),
          helperText: "e.g. Standard EADGBE",
          initialSelection: initialName,
          dropdownMenuEntries: all
              .map((e) => DropdownMenuEntry(value: e.name, label: e.name))
              .toList(),
          onSelected: (String? value) {
            if (value == null) return;
            final selected = all.firstWhere((e) => e.name == value, orElse: () => _defaultList.first);
            if (widget.onChanged != null) widget.onChanged!(selected);
          },
        ),
        /*OutlinedButton(
          onPressed: () {},
          child: Text("Add Custom Tuning"),
        ),*/
      ],
    );
  }
}
