import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/detuning_matrix_measure_navigation.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_page.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrix_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// We subclass ConsumerStatefulWidget instead of StatefulWidget

@RoutePage()
class DetuningMatrixMeasurePage extends ConsumerWidget {
  const DetuningMatrixMeasurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var detuningMatrixMeasureState = ref.watch(
      detuningMatrixMeasureStateProvider,
    );
    return DefaultTabController(
      length: detuningMatrixMeasureState.getCurrentSamples.length,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DetuningMatrixMeasureNavigation(),
          GuitarStateMeasurePage(),
          Builder(
            builder: (innerContext) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    ref
                        .read(detuningMatrixMeasureStateProvider.notifier)
                        .deleteCurrentSample();
                  },
                  child: Text("Delete Sample"),
                ),
                OutlinedButton(
                  onPressed: () async {
                    ref
                        .read(detuningMatrixMeasureStateProvider.notifier)
                        .addSampleForCurrentEffectingString();
                    DefaultTabController.of(innerContext).animateTo(
                      detuningMatrixMeasureState.getCurrentSamples.length,
                    );
                  },
                  child: Text("Add Sample"),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () async {
              var selectedDetuningMatrix = ref
                  .read(selectedDetuningMatrixProvider)
                  .value!;

              ref
                  .read(detuningMatricesProvider.notifier)
                  .saveDetuningMatrixOverriding(selectedDetuningMatrix);
              context.router.pop();
            },
            child: Text("Done"),
          ),
        ],
      ),
    );
  }
}
