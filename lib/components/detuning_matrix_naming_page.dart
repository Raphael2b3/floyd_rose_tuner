import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/display_error.dart';
import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
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
  late TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void initListeners() {
    var selectedDetuningMatrix = ref.read(selectedDetuningMatrixProvider).value;
    textEditingController.text = selectedDetuningMatrix?.guitarName ?? "";
    ref.listen(selectedDetuningMatrixProvider, (previous, next) {
      if (next.value?.guitarName != textEditingController.text) {
        textEditingController.text = next.value?.guitarName ?? "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initListeners();

    DetuningMatrix? selectedDetuningMatrix = ref
        .watch(selectedDetuningMatrixProvider)
        .value;

    if (selectedDetuningMatrix == null) {
      return DisplayError("selectedDetuningMatrix is null");
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Grandpas Les Paul",
            helperText: "Name Your Guitar",
          ),
          controller: textEditingController,
          onChanged: (value) {
            ref
                .read(detuningMatricesProvider.notifier)
                .tryChangeGuitarName(selectedDetuningMatrix.guitarName, value);

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
