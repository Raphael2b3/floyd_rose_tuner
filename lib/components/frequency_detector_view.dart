import 'package:floyd_rose_tuner/components/volume_threshold_selector.dart';
import 'package:floyd_rose_tuner/provider/detected_frequency_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/types/guitare_state_measure_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

class FrequencyDetectorView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var detectedFrequency = ref.watch(detectedFrequencyProvider);

    var detectedFrequencyNotifier = ref.read(
      detectedFrequencyProvider.notifier,
    );
    if (!detectedFrequency.hasValue) {
      return const Text("Loading...");
    }
    var guitarStateMeasureState = ref.watch(guitarStateMeasureStateProvider);
    var guitarState = ref.watch(guitarStateProvider);
    final guitarVals = guitarState.value ?? List<double>.filled(6, 0.0);
    final idx = guitarStateMeasureState.currentStringIndex;
    var currentFrequency =
        (idx >= 0 && idx < guitarVals.length) ? guitarVals[idx] : 0.0;

    return Column(
      children: [
        VolumeThresholdSelector(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Detectet Frequency:"),
            IntrinsicWidth(
              child: TextField(
                controller: TextEditingController(
                  text: currentFrequency.toStringAsFixed(2),
                ),
                enabled: guitarStateMeasureState.manualDetection,
                onChanged: (string) {
                  if (guitarStateMeasureState.manualDetection) {
                    var value = double.tryParse(string) ?? 0.0;
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
                .set(
                  GuitarStateMeasureState(
                    currentStringIndex:
                        guitarStateMeasureState.currentStringIndex,
                    manualDetection: !guitarStateMeasureState.manualDetection,
                  ),
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
