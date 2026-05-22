import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/error_display.dart';
import 'package:floyd_rose_tuner/components/guitar_state_view.dart';
import 'package:floyd_rose_tuner/provider/calibration_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitars_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:floyd_rose_tuner/types/calibration_state.dart';
import 'package:floyd_rose_tuner/types/guitar.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/types/tuning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class CalibrationControlPage extends ConsumerStatefulWidget {
  const CalibrationControlPage({super.key});

  @override
  ConsumerState<CalibrationControlPage> createState() =>
      _CalibrationControlPageState();
}

class _CalibrationControlPageState extends ConsumerState<CalibrationControlPage>
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
  }

  @override
  void dispose() {
    stringTabController.dispose();
    sampleTabController.dispose();
    super.dispose();
  }

  void initListeners() {
    // syncs tabcontroller length with detuningMeasureStateProvider
    ref.listen(selectedGuitarProvider, (previous, next) {
      int effectingStringIndex = ref
          .read(calibrationStateProvider)
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
    CalibrationState calibrationState = ref.read(calibrationStateProvider);
    int currentEffectingStringIndex =
        calibrationState.currentEffectingStringIndex;

    ref
        .read(selectedGuitarProvider.notifier)
        .addSampleForEffectingString(guitarState, currentEffectingStringIndex);
  }

  void removeSample() {
    CalibrationState calibrationState = ref.read(calibrationStateProvider);
    int currentEffectingStringIndex =
        calibrationState.currentEffectingStringIndex;
    int currentSampleIndex = calibrationState.currentSampleIndex;

    ref
        .read(selectedGuitarProvider.notifier)
        .deleteSample(currentEffectingStringIndex, currentSampleIndex);
  }

  @override
  Widget build(BuildContext context) {
    initListeners();
    CalibrationState calibrationState = ref.watch(calibrationStateProvider);
    sampleTabController.animateTo(calibrationState.currentSampleIndex);
    stringTabController.animateTo(calibrationState.currentEffectingStringIndex);
    Guitar? selectedGuitar = ref.watch(selectedGuitarProvider).value;

    Tuning? tuningConfig = ref.watch(selectedTuningProvider).value;
    if (selectedGuitar == null || tuningConfig == null) {
      return ErrorDisplay(
        "Somehow No Guitar is Selected"
        "Somehow No Tuning is Selected",
      );
    }

    List<GuitarState> samples = selectedGuitar.getSamplesForEffectingString(
      calibrationState.currentEffectingStringIndex,
    );
    List<bool>? sampleValidation = selectedGuitar
        .getValidationForEffectingString(
          calibrationState.currentEffectingStringIndex,
        );

    String currentMeasuredStringName =
        tuningConfig.goalNotes[calibrationState.currentEffectingStringIndex];
    var guitarValidation = selectedGuitar.validation;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TabBar(
          controller: stringTabController,
          tabAlignment: TabAlignment.center,
          isScrollable: true,
          tabs: List.generate(selectedGuitar.matrix.length, (i) {
            return Tab(
              child: Badge(
                isLabelVisible: !(guitarValidation[i]),
                child: Text(tuningConfig.goalNotes[i]),
              ),
            );
          }),
          onTap: (index) {
            ref
                    .read(calibrationStateProvider.notifier)
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
            ref.read(calibrationStateProvider.notifier).currentSampleIndex =
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
        GuitarStateView(samples[calibrationState.currentSampleIndex]),
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
              onPressed: selectedGuitar.isValid
                  ? () async {
                      ref
                          .read(selectedGuitarProvider.notifier)
                          .calculateMatrix();
                      Guitar? guitar = ref.read(selectedGuitarProvider).value;
                      if (guitar == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("No Guitar Selected!")),
                        );
                        return;
                      }
                      await ref
                          .read(guitarsProvider.notifier)
                          .saveOverriding(guitar);

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
