import 'package:floyd_rose_tuner/components/volume_threshold_selector.dart';
import 'package:floyd_rose_tuner/provider/detected_frequency_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:floyd_rose_tuner/types/guitare_state_measure_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

class FrequencyDetectorView extends ConsumerWidget {
  const FrequencyDetectorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double? detectedFrequency = ref.watch(detectedFrequencyProvider).value;
    if (detectedFrequency == null) {
      return const Text("Loading...");
    }
    DetectedFrequencyNotifier detectedFrequencyNotifier = ref.read(
      detectedFrequencyProvider.notifier,
    );

    GuitarStateMeasureState guitarStateMeasureState = ref.watch(guitarStateMeasureStateProvider);
    AsyncValue<GuitarState> guitarState = ref.watch(guitarStateProvider);
    final Object guitarVals = guitarState.value ?? List<double>.filled(6, 0.0);
    final int idx = guitarStateMeasureState.currentStringIndex;
    return Column(
      children: [
        VolumeThresholdSelector(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Detected Frequency:"),
            IntrinsicWidth(
              child: TextField(
                controller: TextEditingController(
                  text: detectedFrequency.toStringAsFixed(2),
                ),
                keyboardAppearance: Brightness.light,
                keyboardType: TextInputType.number,
                enabled: guitarStateMeasureState.manualDetection,
                onSubmitted: (stringValue) {
                  if (guitarStateMeasureState.manualDetection) {
                    double value = double.tryParse(stringValue) ?? 0.0;
                    print(
                      "Manually setting detected frequency to $stringValue",
                    );
                    detectedFrequencyNotifier.setDetectedFrequency(value);
                  }
                },
              ),
            ),
          ],
        ),
        FilledButton(
          onPressed: () {
            print("Toggle Manual Detection");
            print(
              "Current  manualdetection ${guitarStateMeasureState.manualDetection}",
            );
            ref
                .read(guitarStateMeasureStateProvider.notifier)
                .guitarStateMeasureState = GuitarStateMeasureState(
              currentStringIndex: guitarStateMeasureState.currentStringIndex,
              manualDetection: !guitarStateMeasureState.manualDetection,
            );
          },
          child: Text(
            "${guitarStateMeasureState.manualDetection ? "Disable" : "Enable"} Manual Input",
          ),
        ),
      ],
    );
  }
}
