import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/frequency_view.dart';
import 'package:floyd_rose_tuner/components/volume_threshold_selector.dart';
import 'package:floyd_rose_tuner/provider/detected_frequency_provider.dart';
import 'package:floyd_rose_tuner/provider/frequency_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:floyd_rose_tuner/provider/smoothed_frequency_stream_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

class FrequencyDetectorView extends ConsumerStatefulWidget {
  const FrequencyDetectorView({super.key});

  @override
  ConsumerState<FrequencyDetectorView> createState() =>
      _FrequencyDetectorViewState();
}

class _FrequencyDetectorViewState extends ConsumerState<FrequencyDetectorView> {
  bool manualInputEnabled = false;
  double lastFrequency = 0.0;

  @override
  Widget build(BuildContext context) {
    var detectedFrequency = ref.watch(detectedFrequencyProvider);
    if (!detectedFrequency.hasValue) {
      return const Text("Loading...");
    }

    if (!manualInputEnabled) lastFrequency = detectedFrequency.requireValue;
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
                      text: lastFrequency.toStringAsFixed(2),
                    ),
                    enabled: manualInputEnabled,
                  ),
                ),
              ],
            ),
            FilledButton(
              onPressed: () {
                setState(() {manualInputEnabled = !manualInputEnabled;});
              },
              child: Text("${manualInputEnabled?"Disable":"Enable"} Manual Input"),
            ),
          ],
        );
  }
}
