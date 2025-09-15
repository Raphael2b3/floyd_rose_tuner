import 'package:floyd_rose_tuner/provider/guitar_behaviour_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/tuning_configuration_provider.dart';
import 'package:floyd_rose_tuner/random_stream.dart';
import 'package:flutter/material.dart';

class TuningConfigurationSelector extends StatefulWidget {
  TuningConfigurationSelector({super.key, this.goal = 0.5});
  double goal;
  @override
  State<TuningConfigurationSelector> createState() => TuningConfigurationSelectorState();
}

class TuningConfigurationSelectorState extends State<TuningConfigurationSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownMenu(
                label: Text("Tuning Configuration"),
                helperText: "e.g. Standard EADGBE",
                initialSelection: selectedTuningConfiguration?.name,
                dropdownMenuEntries: defaultTuningConfigurations
                    .map((e) => DropdownMenuEntry(value: e.name, label: e.name))
                    .toList(),
                onSelected: (String? value) {
                  print(value);
                }),
            /*OutlinedButton(
              onPressed: () {},
              child: Text("Add Custom Tuning"),
            ),*/
          ],
        );
  }
}
