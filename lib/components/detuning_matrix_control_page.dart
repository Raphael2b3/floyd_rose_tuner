import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/display_error.dart';
import 'package:floyd_rose_tuner/components/guitar_state_view.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrix_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix_measure_state.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/types/tuning_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class DetuningMatrixControlPage extends ConsumerStatefulWidget {
  const DetuningMatrixControlPage({super.key});

  @override
  ConsumerState<DetuningMatrixControlPage> createState() =>
      _DetuningMatrixMeasureStatePageState();
}

class _DetuningMatrixMeasureStatePageState
    extends ConsumerState<DetuningMatrixControlPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController stringTabController = TabController(
    length: 6,
    vsync: this,
  );
  late TabController sampleTabController = TabController(
    length: 2, // 2 Default + Plus Symbol
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stringTabController.dispose();
    sampleTabController.dispose();
    super.dispose();
  }

  void initListeners() {
    ref.listen(selectedDetuningMatrixProvider, (previous, next) {
      int effectingStringIndex = ref
          .read(detuningMatrixMeasureStateProvider)
          .currentEffectingStringIndex;

      if ((next.value?.matrix.length ?? 0) != stringTabController.length) {
        setState(() {
          stringTabController = TabController(
            length: next.value?.matrix.length ?? 0,
            vsync: this,
          );
        });
      }
      List<GuitarState> nextSamples =
          next.value?.getSamplesForEffectingString(effectingStringIndex) ?? [];

      if (nextSamples.length != sampleTabController.length) {
        setState(() {
          sampleTabController = TabController(
            length: nextSamples.length,
            vsync: this,
          );
        });
      }
    });
  }

  Future<void> addSample() async {
    GuitarState guitarState = await ref.read(guitarStateProvider.future);
    DetuningMatrixMeasureState detuningMatrixMeasureState = ref.read(
      detuningMatrixMeasureStateProvider,
    );
    int currentEffectingStringIndex =
        detuningMatrixMeasureState.currentEffectingStringIndex;

    ref
        .read(selectedDetuningMatrixProvider.notifier)
        .addSampleForEffectingString(guitarState, currentEffectingStringIndex);
  }

  void removeSample() {
    DetuningMatrixMeasureState detuningMatrixMeasureState = ref.read(
      detuningMatrixMeasureStateProvider,
    );
    int currentEffectingStringIndex =
        detuningMatrixMeasureState.currentEffectingStringIndex;
    int currentSampleIndex = detuningMatrixMeasureState.currentSampleIndex;

    ref
        .read(selectedDetuningMatrixProvider.notifier)
        .deleteSample(currentEffectingStringIndex, currentSampleIndex);
  }

  Future<void> applyMeasurement() async {
    DetuningMatrixMeasureState detuningMatrixMeasureState = ref.read(
      detuningMatrixMeasureStateProvider,
    );
    int currentEffectingStringIndex =
        detuningMatrixMeasureState.currentEffectingStringIndex;
    int currentSampleIndex = detuningMatrixMeasureState.currentSampleIndex;

    GuitarState guitarState = (await ref.read(
      guitarStateProvider.future,
    )).copy(); // copy because otherwise the reference will be the same

    await ref
        .read(selectedDetuningMatrixProvider.notifier)
        .saveSamples(
          guitarState,
          currentEffectingStringIndex,
          currentSampleIndex,
        );

    var nextIndex =
        (sampleTabController.index + 1) % sampleTabController.length;

    if (nextIndex == 0) {
      var nextIndex2 =
          (stringTabController.index + 1) % stringTabController.length;

      stringTabController.animateTo(nextIndex2);
      ref
              .read(detuningMatrixMeasureStateProvider.notifier)
              .currentEffectingStringIndex =
          nextIndex2;
    }
    sampleTabController.animateTo(nextIndex);
    ref.read(detuningMatrixMeasureStateProvider.notifier).currentSampleIndex =
        nextIndex;
  }

  @override
  Widget build(BuildContext context) {
    initListeners();
    DetuningMatrixMeasureState detuningMatrixMeasureState = ref.watch(
      detuningMatrixMeasureStateProvider,
    );
    DetuningMatrix? selectedDetuningMatrix = ref
        .watch(selectedDetuningMatrixProvider)
        .value;

    TuningConfig? tuningConfig = ref.watch(selectedTuningConfigProvider).value;
    if (selectedDetuningMatrix == null ||
        tuningConfig == null
        ) {
      return DisplayError(
        "Somehow No Guitar is Selected"
        "Somehow No Tuning is Selected",
      );
    }

    List<GuitarState> samples = selectedDetuningMatrix
        .getSamplesForEffectingString(
          detuningMatrixMeasureState.currentEffectingStringIndex,
        );
    List<bool>? sampleValidation = selectedDetuningMatrix
        .getValidationForEffectingString(
          detuningMatrixMeasureState.currentEffectingStringIndex,
        );

    String currentMeasuredStringName = tuningConfig
        .goalNotes[detuningMatrixMeasureState.currentEffectingStringIndex];
    var detuningMatrixValidation = selectedDetuningMatrix.validation;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TabBar(
          controller: stringTabController,
          tabAlignment: TabAlignment.center,
          isScrollable: true,
          tabs: List.generate(selectedDetuningMatrix.matrix.length, (i) {
            return Tab(
              child: Badge(
                isLabelVisible: !(detuningMatrixValidation[i]),
                child: Text(tuningConfig.goalNotes[i]),
              ),
            );
          }),
          onTap: (index) {
            ref
                    .read(detuningMatrixMeasureStateProvider.notifier)
                    .currentEffectingStringIndex =
                index;
            sampleTabController.animateTo(0);
          },
        ),
        TabBar(
          controller: sampleTabController,
          tabAlignment: TabAlignment.center,
          isScrollable: true,
          onTap: (value) {
            ref
                    .read(detuningMatrixMeasureStateProvider.notifier)
                    .currentSampleIndex =
                value;
          },
          tabs: List.generate(samples.length, (i) {
            var number = samples.length > 2 ? "$i" : "";
            var text = i == 0
                ? "Initial State"
                : "$currentMeasuredStringName Changed $number";

            if (i == samples.length) {
              return Tab(
                height: 30,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.add),
                  onPressed: addSample,
                ),
              );
            }
            return Tab(
              height: 30,
              child: Badge(
                isLabelVisible: !(sampleValidation[i]),
                child: Row(
                  children: [
                    Text(text),
                    if (samples.length > 2)
                      IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: removeSample,
                        icon: Icon(Icons.remove),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
        GuitarStateView(samples[detuningMatrixMeasureState.currentSampleIndex]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                context.router.popUntilRouteWithName(
                  DetuningMatrixMeasureRoute.name,
                );
              },
              child: Text("Back"),
            ),
            FilledButton(
              onPressed: selectedDetuningMatrix.isValid
                  ? () async {
                ref
                    .read(selectedDetuningMatrixProvider.notifier)
                    .calculateMatrix();
                DetuningMatrix? detuningMatrix = ref
                    .read(selectedDetuningMatrixProvider)
                    .value;
                if (detuningMatrix == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No Guitar Selected!")),
                  );
                  return;
                }
                await ref
                    .read(detuningMatricesProvider.notifier)
                    .saveDetuningMatrixOverriding(detuningMatrix);

                context.router.popUntilRouteWithName(
                  FloydRoseTunerSetupRoute.name,
                );
              }
                  : null,
              child: Text("Done"),
            ),
          ],
        ),
      ],
    );
  }
}
