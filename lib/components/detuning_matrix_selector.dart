import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// We subclass ConsumerWidget instead of StatelessWidget
class DetuningMatrixSelector extends ConsumerWidget {
  // "build" receives an extra parameter
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We can use that "ref" to listen to providers
    final selected = ref.watch(selectedDetuningMatrixProvider).value;
    final detuningMatrices = ref.watch(detuningMatricesProvider).value ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownMenu(
          label: const Text("Select Your Guitar"),
          initialSelection: selected,
          dropdownMenuEntries: detuningMatrices
              .map(
                (e) => DropdownMenuEntry<DetuningMatrix>(
                  value: e,
                  label: e.guitarName,
                ),
              )
              .toList(),
          onSelected: (DetuningMatrix? value) {
            if (value == null) return;
            ref
                .read(selectedDetuningMatrixProvider.notifier)
                .selectDetuningMatrix(value);
          },
        ),
        OutlinedButton(
          onPressed: () {
            ref
                .read(detuningMatricesProvider.notifier)
                .addDetuningMatrix(
                  DetuningMatrix(
                    guitarName: "My New Guitar",
                    matrix: [
                      [1, 2, 3, 4, 5, 6],
                      [1, 2, 3, 4, 5, 6],
                      [1, 2, 3, 4, 5, 6],
                      [1, 2, 3, 4, 5, 6],
                      [1, 2, 3, 4, 5, 6],
                      [1, 2, 3, 4, 5, 6],
                    ],
                  ),
                );
          },
          child: Text("Add A New Guitar"),
        ),
      ],
    );
  }
}
