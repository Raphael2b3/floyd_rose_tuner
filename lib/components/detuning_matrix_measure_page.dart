import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/detuning_matrix_measure_navigation.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_page.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:floyd_rose_tuner/utils/random_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// We subclass ConsumerStatefulWidget instead of StatefulWidget

@RoutePage()
class DetuningMatrixMeasurePage extends ConsumerWidget {
  const DetuningMatrixMeasurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DetuningMatrixMeasureNavigation(),
        GuitarStateMeasurePage(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FilledButton(onPressed: () async {}, child: Text("Delete Sample")),
            FilledButton(onPressed: () async {}, child: Text("Add Sample")),
          ],
        ),
      ],
    );
  }
}
