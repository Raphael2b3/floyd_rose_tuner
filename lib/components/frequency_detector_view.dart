import 'package:floyd_rose_tuner/components/volume_threshold_selector.dart';
import 'package:floyd_rose_tuner/provider/detected_frequency_provider.dart';
import 'package:floyd_rose_tuner/provider/focus_node_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/types/guitare_state_measure_state.dart';
import 'package:floyd_rose_tuner/utils/tone_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FrequencyDetectorView extends ConsumerStatefulWidget {
  const FrequencyDetectorView({super.key});

  @override
  ConsumerState<FrequencyDetectorView> createState() =>
      FrequencyDetectorViewState();
}

class FrequencyDetectorViewState extends ConsumerState<FrequencyDetectorView> {
  @override
  Widget build(BuildContext context) {
    double? detectedFrequency = ref.watch(detectedFrequencyProvider).value;
    if (detectedFrequency == null) {
      return const Text("Loading...");
    }
    DetectedFrequencyNotifier detectedFrequencyNotifier = ref.read(
      detectedFrequencyProvider.notifier,
    );

    GuitarStateMeasureState guitarStateMeasureState = ref.watch(
      guitarStateMeasureStateProvider,
    );
    FocusNode editingFrequencyFocusNode = ref.watch(
      focusNodeProvider("editingFrequency"),
    );

    return Column(
      children: [
        if (!guitarStateMeasureState.manualDetection) VolumeThresholdSelector(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (guitarStateMeasureState.manualDetection) ...[
              Text("Detected Frequency:"),
              IntrinsicWidth(
                child: TextField(
                  focusNode: editingFrequencyFocusNode,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: !guitarStateMeasureState.manualDetection,
                      onChanged: (value) {
                        ref
                            .read(guitarStateMeasureStateProvider.notifier)
                            .guitarStateMeasureState = GuitarStateMeasureState(
                          currentStringIndex:
                              guitarStateMeasureState.currentStringIndex,
                          manualDetection:
                              !guitarStateMeasureState.manualDetection,
                        );
                      },
                    ),
                  ],
                ),
                Text("Auto Detect"),
                TextButton.icon(
                  onPressed: () async {
                    var frequency = (await ref.read(
                      guitarStateProvider.future,
                    ))[guitarStateMeasureState.currentStringIndex].toDouble();
                    await TonePlayer().playFrequency(frequency);
                  },
                  label: Text("Play Sound"),
                  icon: Icon(Icons.volume_up),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
