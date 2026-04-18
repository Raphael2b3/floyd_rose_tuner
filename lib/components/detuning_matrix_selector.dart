import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
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
            ref
                .read(detuningMatricesProvider.notifier)
                .addDetuningMatrix(
                  DetuningMatrix(
                    guitarName: "My New Guitar",
                    //Matrix from paper
                    matrix: <List<double>>[
                      [
                        1.0,
                        -0.13151204,
                        -0.07967868,
                        -0.08285579,
                        -0.03920727,
                        -0.00887611,
                      ],
                      [
                        -0.17081316,
                        1.0,
                        -0.09513059,
                        -0.09088310,
                        -0.04186852,
                        -0.00678739,
                      ],
                      [
                        -0.21073616,
                        -0.17126097,
                        1.0,
                        -0.11291342,
                        -0.05205339,
                        -0.00973759,
                      ],
                      [
                        -0.43013191,
                        -0.37112772,
                        -0.24435172,
                        1.0,
                        -0.12051330,
                        -0.02198811,
                      ],
                      [
                        -0.31517285,
                        -0.27299015,
                        -0.17642330,
                        -0.17988537,
                        1.0,
                        -0.01723553,
                      ],
                      [
                        -0.21696815,
                        -0.18307001,
                        -0.12374466,
                        -0.13078740,
                        -0.06824934,
                        1.0,
                      ],
                    ],
                  ),
                );
            await context.router.push(const GuitarStateMeasureRoute());
          },
          child: Text("Add A New Guitar"),
        ),
      ],
    );
  }
}
