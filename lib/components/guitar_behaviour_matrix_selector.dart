import 'package:floyd_rose_tuner/provider/guitar_behaviour_matrix_provider.dart';
import 'package:flutter/material.dart';

class GuitarBehaviourMatrixSelector extends StatefulWidget {
  GuitarBehaviourMatrixSelector({super.key});
  @override
  State<GuitarBehaviourMatrixSelector> createState() => GuitarBehaviourMatrixSelectorState();
}

class GuitarBehaviourMatrixSelectorState extends State<GuitarBehaviourMatrixSelector> {
  @override
  Widget build(BuildContext context) {
    return
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownMenu(
                label: Text("Your Guitar"),
                initialSelection:  selectedGuitarBehaviourMatrix?.guitarName,
                dropdownMenuEntries: defaultGuitarBehaviourMatrices
                    .map((e) => DropdownMenuEntry(value: e.guitarName, label: e.guitarName))
                    .toList(),
                onSelected: (String? value) {
                  print(value);
                }),
            OutlinedButton(
              onPressed: () {},
              child: Text("Add A Guitar"),
            ),
          ],
        );
  }
}
