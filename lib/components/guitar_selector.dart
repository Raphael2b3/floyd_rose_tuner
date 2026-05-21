import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/provider/guitars_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/guitar.dart';
import 'package:floyd_rose_tuner/utils/random_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_linalg/matrix.dart';

// We subclass ConsumerWidget instead of StatelessWidget
class GuitarSelector extends ConsumerWidget {
  const GuitarSelector({super.key});

  // "build" receives an extra parameter
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // safe handling of AsyncValue
    Guitar? selectedGuitar = ref
        .watch(selectedGuitarProvider)
        .value;
    final List<Guitar>? guitars = ref
        .watch(guitarsProvider)
        .value;
    if (guitars == null) {
      return Column(
        children: [
          Text(" Detuning Matrices is null"),
          CircularProgressIndicator(),
        ],
      );
    }
    if (!guitars.contains(selectedGuitar)) {
      selectedGuitar = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownMenu(
          width: double.infinity,
          label: const Text("Select Your Guitar"),
          initialSelection: selectedGuitar,
          // //  Failed assertion: line 4179 pos 14: 'debugNeedsLayout': is not true.
          dropdownMenuEntries: guitars
              .map(
                (e) => DropdownMenuEntry<Guitar>(
                  value: e,
                  label: e.guitarName,
                  leadingIcon: IconButton(
                    onPressed: () async {
                      ref
                          .read(selectedGuitarProvider.notifier)
                          .select(e);
                      await context.router.push(
                        const CalibrationRoute(),
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
                                    .read(guitarsProvider.notifier)
                                    .remove(e.guitarName);
                                ref
                                    .read(
                                      selectedGuitarProvider.notifier,
                                    )
                                    .select(null);
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
          onSelected: (Guitar? value) {
            if (value == null) return;
            ref
                .read(selectedGuitarProvider.notifier)
                .select(value);
          },
        ),
        OutlinedButton(
          onPressed: () async {
            Matrix freshMatrix = Matrix.fromList([
              [1, 0, 0, 0, 0, 0],
              [0, 1, 0, 0, 0, 0],
              [0, 0, 1, 0, 0, 0],
              [0, 0, 0, 1, 0, 0],
              [0, 0, 0, 0, 1, 0],
              [0, 0, 0, 0, 0, 1],
            ]);

            ref
                .read(selectedGuitarProvider.notifier)
                .select(
                  Guitar(
                    guitarName: "New Guitar ${random.nextInt(5555)}",
                    matrix: freshMatrix,
                  ),
                );
            await context.router.push(const GuitarRoute());
          },
          child: Text("Add A New Guitar"),
        ),
      ],
    );
  }
}
