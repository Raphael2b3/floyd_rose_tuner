import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrix_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix_measure_state.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetuningMatrixMeasureNavigation extends ConsumerWidget {
  const DetuningMatrixMeasureNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<DetuningMatrix?> selectedDetuningMatrix = ref.watch(selectedDetuningMatrixProvider);
    DetuningMatrixMeasureState detuningMatrixMeasureState = ref.watch(
      detuningMatrixMeasureStateProvider,
    );

    // after the null-check above it's safe to assign to non-nullable locals
    final detuningMatrix = selectedDetuningMatrix.value;
    if (detuningMatrix == null) {
      return Text("No Detuning Matrix Selected");
    }
    List<GuitarState> samples = detuningMatrix.getSamplesForEffectingString(
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

            ref
                .read(selectedDetuningMatrixProvider.notifier)
                .selectDetuningMatrix(detuningMatrix.copy(guitarName: value));
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
                      .currentEffectingStringIndex =
                  index;
              DefaultTabController.of(context).animateTo(0);
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
                    .currentSampleIndex =
                index;
          },
        ),
        Row(
          children: [
            IconButton(
              onPressed: () async {
                DetuningMatrixMeasureState detuningMatrixMeasureState = ref.read(
                  detuningMatrixMeasureStateProvider,
                );
                int currentEffectingStringIndex =
                    detuningMatrixMeasureState.currentEffectingStringIndex;
                int currentSampleIndex =
                    detuningMatrixMeasureState.currentSampleIndex;

                GuitarState guitarState = await ref.read(
                  guitarStateProvider.future,
                );

                ref
                    .read(selectedDetuningMatrixProvider.notifier)
                    .saveSamples(
                      guitarState,
                      currentEffectingStringIndex,
                      currentSampleIndex,
                    );
              },
              icon: Icon(Icons.save),
            ),
            Text(
              "Current Sample: ${samples[detuningMatrixMeasureState.currentSampleIndex]} Hz",
              softWrap: true,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
