import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_page.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrix_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/focus_node_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix_measure_state.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/types/tuning_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// We subclass ConsumerStatefulWidget instead of StatefulWidget
@RoutePage()
class DetuningMatrixMeasurePage extends ConsumerStatefulWidget {
  const DetuningMatrixMeasurePage({super.key});

  @override
  ConsumerState<DetuningMatrixMeasurePage> createState() =>
      _DetuningMatrixMeasureStatePageState();
}

class _DetuningMatrixMeasureStatePageState
    extends ConsumerState<DetuningMatrixMeasurePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController stringTabController = TabController(
    length: 6,
    vsync: this,
  );
  late TabController sampleTabController = TabController(
    length: 2,
    vsync: this,
  );

  late TextEditingController textEditingController = TextEditingController();

  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final visible =
        WidgetsBinding
            .instance
            .platformDispatcher
            .views
            .first
            .viewInsets
            .bottom >
        0;
    if (visible != isKeyboardVisible) {
      setState(() => isKeyboardVisible = visible);
      // Falls du den Provider noch brauchst:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    textEditingController.dispose();
    stringTabController.dispose();
    sampleTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DetuningMatrixMeasureState detuningMatrixMeasureState = ref.watch(
      detuningMatrixMeasureStateProvider,
    );
    DetuningMatrix? selectedDetuningMatrix = ref
        .watch(selectedDetuningMatrixProvider)
        .value;

    if (selectedDetuningMatrix == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("selectedDetuningMatrix is null"),
            CircularProgressIndicator(),
          ],
        ),
      );
    }

    TuningConfig? tuningConfig = ref.watch(selectedTuningConfigProvider).value;
    if (tuningConfig == null) {
      return Text("No Tuning Configs Loaded");
    }

    List<GuitarState> samples = selectedDetuningMatrix
        .getSamplesForEffectingString(
          detuningMatrixMeasureState.currentEffectingStringIndex,
        );
    var noAutofocusName =
        ref
            .read(detuningMatricesProvider)
            .value
            ?.contains(selectedDetuningMatrix) ??
        false;

    ref.listen(selectedDetuningMatrixProvider, (previous, next) {
      int effectingStringIndex = ref
          .read(detuningMatrixMeasureStateProvider)
          .currentEffectingStringIndex;

      List<GuitarState> nextSamples =
          next.value?.getSamplesForEffectingString(effectingStringIndex) ?? [];
      if ((next.value?.matrix.length ?? 0) != stringTabController.length) {
        setState(() {
          stringTabController = TabController(
            length: next.value?.matrix.length ?? 0,
            vsync: this,
          );
        });
      }
      if (nextSamples.length != sampleTabController.length) {
        setState(() {
          sampleTabController = TabController(
            length: nextSamples.length,
            vsync: this,
          );
        });
      }
      if (next.value?.guitarName != textEditingController.text) {
        textEditingController.text = next.value?.guitarName ?? "null";
      }
    });
    textEditingController.text = selectedDetuningMatrix.guitarName;
    print("IS KEYBOARD VISIBLE $isKeyboardVisible");
    FocusNode guitarNameFocusNode = ref.watch(focusNodeProvider("guitarName"));

    bool editingName = isKeyboardVisible && guitarNameFocusNode.hasFocus;
    bool editingFrequency = isKeyboardVisible && !guitarNameFocusNode.hasFocus;
    return Expanded(
      child: Center(
        child: Column(
          children: [
            Text("Give It A Name", style: TextStyle(fontSize: 20)),

            Visibility(
              visible: !editingFrequency,
              child: TextField(
                focusNode: guitarNameFocusNode,
                autofocus: !noAutofocusName,
                controller: textEditingController,
                onChanged: (value) {
                  ref
                      .read(detuningMatricesProvider.notifier)
                      .changeGuitarName(selectedDetuningMatrix.guitarName, value);

                  ref
                      .read(selectedDetuningMatrixProvider.notifier)
                      .selectDetuningMatrix(
                        selectedDetuningMatrix.copy(guitarName: value),
                      );
                  textEditingController.text = value;
                },
              ),
            ),

            if (!isKeyboardVisible) ...[
              Text("Select Effecting String", style: TextStyle(fontSize: 20)),
              TabBar(
                controller: stringTabController,
                tabAlignment: TabAlignment.center,
                isScrollable: true,
                tabs: List.generate(selectedDetuningMatrix.matrix.length, (i) {
                  return Tab(child: Text(tuningConfig.goalNotes[i]));
                }),
                onTap: (index) {
                  ref
                          .read(detuningMatrixMeasureStateProvider.notifier)
                          .currentEffectingStringIndex =
                      index;
                  sampleTabController.animateTo(0);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (samples.length > 2)
                    TextButton.icon(
                      onPressed: () async {
                        DetuningMatrixMeasureState detuningMatrixMeasureState = ref
                            .read(detuningMatrixMeasureStateProvider);
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
                      label: Text("Delete"),
                      icon: Icon(Icons.delete_outline),
                    ),
                  Text("Measurements"),
                  TextButton.icon(
                    onPressed: () async {
                      GuitarState guitarState = await ref.read(
                        guitarStateProvider.future,
                      );
                      DetuningMatrixMeasureState detuningMatrixMeasureState = ref
                          .read(detuningMatrixMeasureStateProvider);
                      int currentEffectingStringIndex =
                          detuningMatrixMeasureState.currentEffectingStringIndex;

                      ref
                          .read(selectedDetuningMatrixProvider.notifier)
                          .addSampleForEffectingString(
                            guitarState,
                            currentEffectingStringIndex,
                          );
                    },
                    label: Text("Add"),
                    icon: Icon(Icons.control_point_outlined),
                  ),
                ],
              ),
              TabBar(
                controller: sampleTabController,
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
                  print(
                    "Current sample index: ${ref.read(detuningMatrixMeasureStateProvider).currentSampleIndex}",
                  );
                },
              ),
              Text("Measurement:"),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Text(
                      samples[detuningMatrixMeasureState.currentSampleIndex].indexed
                          .map((e) {
                            int i = e.$1;
                            var element = e.$2;
                            return element.toStringAsFixed(2);
                            return "${tuningConfig.goalNotes[i]}: ${element.toStringAsFixed(2)}";
                          })
                          .join(" | "),
                      softWrap: true,
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
            Visibility(
              visible: !editingName,
              child: Column(
                children: [
                  GuitarStateMeasurePage(),
                  OutlinedButton.icon(
                    onPressed: () async {
                      DetuningMatrixMeasureState detuningMatrixMeasureState = ref
                          .read(detuningMatrixMeasureStateProvider);
                      int currentEffectingStringIndex =
                          detuningMatrixMeasureState.currentEffectingStringIndex;
                      int currentSampleIndex =
                          detuningMatrixMeasureState.currentSampleIndex;

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
                    },
                    label: Text(
                      "Apply Measurement",
                      style: TextStyle(fontSize: 20),
                    ),
                    icon: Icon(Icons.camera_alt_outlined),
                  ),

                  if (selectedDetuningMatrix.hasValidSamples)
                    FilledButton(
                      onPressed: () async {
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

                        context.router.pop();
                      },
                      child: Text("Done"),
                    )
                  else
                    Text("Something Still Needs To Be Measured"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
