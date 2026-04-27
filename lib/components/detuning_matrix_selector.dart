import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:floyd_rose_tuner/utils/random_stream.dart';
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
    final matricesAsync = ref.watch(detuningMatricesProvider);
    final detuningMatrices = matricesAsync.value ?? [];
    final selected = selectedAsync.value;

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
                  leadingIcon: IconButton(
                    onPressed: () async {
                      ref
                          .read(selectedDetuningMatrixProvider.notifier)
                          .selectDetuningMatrix(e);
                      await context.router.push(
                        const DetuningMatrixMeasureRoute(),
                      );
                    },
                    icon: Icon(Icons.edit),
                  ),
                  trailingIcon: IconButton(
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete The Guitar'),
                          content: const Text(
                            'Do you really want to delete the guitar?',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () {
                                ref
                                    .read(detuningMatricesProvider.notifier)
                                    .removeDetuningMatrix(e.guitarName);
                                Navigator.pop(context, 'OK');
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.delete),
                  ),
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
          onPressed: () async {
            List<List<double>> freshMatrix = [
              [1, 0, 0, 0, 0, 0],
              [0, 1, 0, 0, 0, 0],
              [0, 0, 1, 0, 0, 0],
              [0, 0, 0, 1, 0, 0],
              [0, 0, 0, 0, 1, 0],
              [0, 0, 0, 0, 0, 1],
            ];

            ref
                .read(selectedDetuningMatrixProvider.notifier)
                .selectDetuningMatrix(
                  DetuningMatrix(
                    guitarName: "New Guitar ${random.nextInt(5555)}",
                    matrix: freshMatrix,
                  ),
                );
            await context.router.push(const DetuningMatrixMeasureRoute());
          },
          child: Text("Add A New Guitar"),
        ),
        FilledButton(
          onPressed: () async {
            var detuningMatrix = ref.read(selectedDetuningMatrixProvider);

            print(detuningMatrix.value?.samples);
          },
          child: Text("Debug"),
        ),
      ],
    );
  }
}
