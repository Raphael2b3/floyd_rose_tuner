import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/provider/guitars_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/guitar.dart';
import 'package:floyd_rose_tuner/utils/floyd_rose_delta_frequencies.dart';
import 'package:floyd_rose_tuner/utils/optional_badge_wrapper.dart';
import 'package:floyd_rose_tuner/utils/random_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_linalg/matrix.dart';

// We subclass ConsumerWidget instead of StatelessWidget
class GuitarSelector extends ConsumerWidget {
  Guitar? selectedGuitar;

  List<Guitar>? guitars;

  GuitarSelector({super.key});

  // "build" receives an extra parameter
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // safe handling of AsyncValue
    selectedGuitar = ref.watch(selectedGuitarProvider).value;
    guitars = ref.watch(guitarsProvider).value;
    if (guitars == null) {
      return Column(
        children: [
          Text(" Detuning Matrices is null"),
          CircularProgressIndicator(),
        ],
      );
    }
    if (!guitars!.contains(selectedGuitar)) {
      selectedGuitar = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownMenu(
          label: const Text("Select Your Guitar"),
          initialSelection: selectedGuitar,
          expandedInsets: EdgeInsets.zero,
          dropdownMenuEntries: guitars!.map((e) {
            return DropdownMenuEntry<Guitar>(
              value: e,
              label: e.guitarName,
              labelWidget: OptionalBadgeWrapper(
                child: Text(e.guitarName),
                showBadge: !e.isValid,
              ),
              leadingIcon: IconButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pop(); // or MenuController if you have access
                  ref.read(selectedGuitarProvider.notifier).select(e);
                  context.router.push(const GuitarRoute());
                },
                icon: OptionalBadgeWrapper(
                  child: Icon(Icons.edit),
                  showBadge: !e.isValid,
                ),
              ),
            );
          }).toList(),
          onSelected: (Guitar? value) {
            if (value == null) return;
            ref.read(selectedGuitarProvider.notifier).select(value);
          },
        ),
        OutlinedButton(
          onPressed: () async {
            Matrix freshMatrix = Matrix.fromList(exampleMatrix);
            var newGuitar = Guitar(
              guitarName: "New Guitar ${random.nextInt(5555)}",
              matrix: freshMatrix,
            );
            ref.read(selectedGuitarProvider.notifier).select(newGuitar);
            ref.read(guitarsProvider.notifier).saveOverriding(newGuitar);

            await context.router.navigate(const GuitarRoute());
          },
          child: Text("Add A New Guitar"),
        ),
      ],
    );
  }
}
