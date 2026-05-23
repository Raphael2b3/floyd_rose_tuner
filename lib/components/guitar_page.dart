import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/error_display.dart';
import 'package:floyd_rose_tuner/provider/calibration_state_provider.dart';
import 'package:floyd_rose_tuner/provider/string_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitars_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/guitar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//#region Statfulpage
@RoutePage()
class GuitarPage extends ConsumerStatefulWidget {
  const GuitarPage({super.key});

  @override
  ConsumerState<GuitarPage> createState() => _GuitarPageState();
}
//#endregion

class _GuitarPageState extends ConsumerState<GuitarPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void initListeners() {
    var selectedGuitar = ref.read(selectedGuitarProvider).value;
    textEditingController.text = selectedGuitar?.guitarName ?? "";
    ref.listen(selectedGuitarProvider, (previous, next) {
      if (next.value?.guitarName != textEditingController.text) {
        textEditingController.text = next.value?.guitarName ?? "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initListeners();

    Guitar? selectedGuitar = ref.watch(selectedGuitarProvider).value;

    if (selectedGuitar == null) {
      return ErrorDisplay("selectedGuitar is null");
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              label: Text("Delete"),
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Delete The Guitar'),
                    content: Text(
                      'Do you really want to delete ${selectedGuitar.guitarName}?',
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () {
                          ref
                              .read(guitarsProvider.notifier)
                              .remove(selectedGuitar.guitarName);
                          ref.read(selectedGuitarProvider.notifier).selectAny();
                          Navigator.pop(context, 'OK');
                          context.router.back();
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
        TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Grandpas Les Paul",
            helperText: "Name Your Guitar",
          ),
          controller: textEditingController,
          onChanged: (value) {
            ref
                .read(guitarsProvider.notifier)
                .tryChangeName(selectedGuitar.guitarName, value);

            ref
                .read(selectedGuitarProvider.notifier)
                .select(selectedGuitar.copy(guitarName: value));
            textEditingController.text = value;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                context.router.navigate(FloydRoseTunerSetupRoute());
              },
              child: Text("Back"),
            ),
            if (!selectedGuitar.isValid)
              Badge(
                child: Column(
                  children: [
                    FilledButton(
                      onPressed: () {
                        ref.read(calibrationStateProvider.notifier)
                          ..currentSampleIndex = 0
                          ..currentEffectingStringIndex = 0;
                        ref
                                .read(stringMeasureStateProvider.notifier)
                                .currentStringIndex =
                            0;
                        context.router.navigate(const CalibrationLayoutRoute());
                      },
                      child: Text("Calibrate This Guitar"),
                    ),
                    Text("This Guitar Needs Calibration"),
                  ],
                ),
              )
            else
              OutlinedButton(
                onPressed: () {
                  context.router.navigate(const CalibrationLayoutRoute());
                },
                child: Text("Recalibrate"),
              ),
          ],
        ),
      ],
    );
  }
}
