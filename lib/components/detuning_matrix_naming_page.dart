import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/focus_node_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:floyd_rose_tuner/types/tuning_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//#region Statfulpage
@RoutePage()
class DetuningMatrixNamingPage extends ConsumerStatefulWidget {
  const DetuningMatrixNamingPage({super.key});

  @override
  ConsumerState<DetuningMatrixNamingPage> createState() =>
      _DetuningMatrixMeasureStatePageState();
}
//#endregion

class _DetuningMatrixMeasureStatePageState
    extends ConsumerState<DetuningMatrixNamingPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  //#region Fields

  late TextEditingController textEditingController = TextEditingController();
  bool isKeyboardVisible = false;
  bool nameEditing = true;
  late FocusNode guitarNameFocusNode;

  //#endregion

  //#region Methods
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    guitarNameFocusNode = ref.read(focusNodeProvider(guitarNameFocusNodeID));
    print("INIT STATE $guitarNameFocusNode");
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
    super.dispose();
  }

  void initListeners() {
    ref.listen(selectedDetuningMatrixProvider, (previous, next) {
      if (next.value?.guitarName != textEditingController.text) {
        textEditingController.text = next.value?.guitarName ?? "null";
      }
    });
  }

  //#endregion

  @override
  Widget build(BuildContext context) {
    initListeners();

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

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextFormField(
          //selectAllOnFocus: true,
          decoration: InputDecoration(
            hintText: "Grandpas Les Paul",
            helperText: "Name Your Guitar",
          ),
          focusNode: guitarNameFocusNode,
          controller: textEditingController,
          onSaved: (newValue) => setState(() => nameEditing = false),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                context.router.back();
                ref
                    .read(selectedDetuningMatrixProvider.notifier)
                    .selectDetuningMatrix(null);
              },
              child: Text("Back"),
            ),
            FilledButton(
              onPressed: () {
                context.router.push(const DetuningMatrixMeasureRoute());
              },
              child: Text("Teach the App Your Guitar"),
            ),
          ],
        ),
      ],
    );
  }
}
