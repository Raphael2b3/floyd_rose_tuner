import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/detuning_matrix_measure_navigation.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_page.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrix_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix_measure_state.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// We subclass ConsumerStatefulWidget instead of StatefulWidget

@RoutePage()
class DetuningMatrixMeasurePage extends ConsumerWidget {
  const DetuningMatrixMeasurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DetuningMatrixMeasureState detuningMatrixMeasureState = ref.watch(
      detuningMatrixMeasureStateProvider,
    );
    AsyncValue<DetuningMatrix?> nullableSelectedDetuningMatrix = ref.watch(
      selectedDetuningMatrixProvider,
    );

    if (nullableSelectedDetuningMatrix.value == null) {
      return Center(child: CircularProgressIndicator());
    }
    DetuningMatrix? selectedDetuningMatrix = nullableSelectedDetuningMatrix.value;
    if (selectedDetuningMatrix == null) {
      return Text("No Detuning Matrix Selected");
    }
    return DefaultTabController(
      length: selectedDetuningMatrix
          .getSamplesForEffectingString(
            detuningMatrixMeasureState.currentEffectingStringIndex,
          )
          .length,
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
                    DetuningMatrixMeasureState detuningMatrixMeasureState = ref.read(
                      detuningMatrixMeasureStateProvider,
                    );
                    int currentEffectingStringIndex =
                        detuningMatrixMeasureState.currentEffectingStringIndex;
                    int currentSampleIndex =
                        detuningMatrixMeasureState.currentSampleIndex;

                    ref
                        .read(selectedDetuningMatrixProvider.notifier)
                        .deleteSample(
                          currentEffectingStringIndex,
                          currentSampleIndex,
                        );
                  },
                  child: Text("Delete Sample"),
                ),
                OutlinedButton(
                  onPressed: () async {
                    GuitarState guitarState = await ref.read(
                      guitarStateProvider.future,
                    );
                    DetuningMatrixMeasureState detuningMatrixMeasureState = ref.read(
                      detuningMatrixMeasureStateProvider,
                    );
                    int currentEffectingStringIndex =
                        detuningMatrixMeasureState.currentEffectingStringIndex;

                    ref
                        .read(selectedDetuningMatrixProvider.notifier)
                        .addSampleForEffectingString(
                          guitarState,
                          currentEffectingStringIndex,
                        );
                  },
                  child: Text("Add Sample"),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FilledButton(
                onPressed: () async {
                  ref.read(selectedDetuningMatrixProvider.notifier);
                  //.calculateMatrix();
                  DetuningMatrix? detuningMatrix = ref
                      .read(selectedDetuningMatrixProvider)
                      .value;
                  if (detuningMatrix == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No Guitar Selected!")),
                    );
                    return;
                  }
                  ref
                      .read(detuningMatricesProvider.notifier)
                      .saveDetuningMatrixOverriding(detuningMatrix);

                  context.router.pop();
                },
                child: Text("Done"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
