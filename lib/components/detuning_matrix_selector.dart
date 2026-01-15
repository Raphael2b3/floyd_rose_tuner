import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// We subclass ConsumerWidget instead of StatelessWidget
class DetuningMatrixSelector extends ConsumerWidget {
  const DetuningMatrixSelector({super.key});

  // "build" receives an extra parameter
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // safe handling of AsyncValue
    final selectedAsync = ref.watch(selectedDetuningMatrixProvider);
    final selected = selectedAsync.value;
    final matricesAsync = ref.watch(detuningMatricesProvider);
    final detuningMatrices = matricesAsync.value ?? [];

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
                    matrix: <List<double>>[
                      [1.0, 2.0, 3.0, 4.0, 5.0, 6.0],
                      [1.0, 2.0, 3.0, 4.0, 5.0, 6.0],
                      [1.0, 2.0, 3.0, 4.0, 5.0, 6.0],
                      [1.0, 2.0, 3.0, 4.0, 5.0, 6.0],
                      [1.0, 2.0, 3.0, 4.0, 5.0, 6.0],
                      [1.0, 2.0, 3.0, 4.0, 5.0, 6.0],
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
