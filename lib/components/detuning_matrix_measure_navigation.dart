import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrix_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetuningMatrixMeasureNavigation extends ConsumerWidget {
  const DetuningMatrixMeasureNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedDetuningMatrix = ref.watch(selectedDetuningMatrixProvider);
    var detuningMatrixMeasureState = ref.watch(
      detuningMatrixMeasureStateProvider,
    );
    if (selectedDetuningMatrix.value == null) {
      return Text("Loading...");
    }
    // after the null-check above it's safe to assign to non-nullable locals
    final detuningMatrix = selectedDetuningMatrix.value!;
    var samples = detuningMatrix.getSamplesForEffectingString(
      detuningMatrixMeasureState.currentEffectingStringIndex,
    );
    return Column(
      children: [
        TextField(
          controller: TextEditingController(text: detuningMatrix.guitarName),
          onSubmitted: (value) {
            ref
                .read(detuningMatricesProvider.notifier)
                .changeGuitarName(detuningMatrix.guitarName, value);
          },
        ),
        Divider(),
        Text("Effecting String:"),
        DefaultTabController(
          length: detuningMatrix.matrix.length,
          child: TabBar(
            tabAlignment: TabAlignment.center,
            isScrollable: true,
            tabs: List.generate(detuningMatrix.matrix.length, (i) {
              return Tab(child: Text("${i + 1}"));
            }),
            onTap: (index) {
              ref
                  .read(detuningMatrixMeasureStateProvider.notifier)
                  .set(
                    detuningMatrixMeasureState.copy(
                      currentEffectingStringIndex: index,
                    ),
                  );
            },
          ),
        ),
        Text("Samples (minimum 2):"),
        TabBar(
          tabAlignment: TabAlignment.center,
          isScrollable: true,
          tabs: List.generate(samples.length, (i) {
            return Tab(child: Text("${i + 1}"));
          }),
          onTap: (index) {
            ref
                .read(detuningMatrixMeasureStateProvider.notifier)
                .set(
                  detuningMatrixMeasureState.copy(currentSampleIndex: index),
                );
          },
        ),
      ],
    );
  }
}
