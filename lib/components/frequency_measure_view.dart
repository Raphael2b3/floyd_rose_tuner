import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/frequency_view.dart';
import 'package:floyd_rose_tuner/provider/frequency_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

class FrequencyMeasureView extends ConsumerStatefulWidget {
  const FrequencyMeasureView({super.key});

  @override
  ConsumerState<FrequencyMeasureView> createState() =>
      _FrequencyMeasureViewState();
}

class _FrequencyMeasureViewState extends ConsumerState<FrequencyMeasureView> {
  bool manualInputEnabled = false;
  double lastFrequency = 0.0;

  @override
  Widget build(BuildContext context) {
    var frequencyStream = ref.watch(frequencyStreamProvider);
    return StreamBuilder(
      stream: frequencyStream.value,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (!snapshot.hasData) return const Text("No Data");
        var frequency = snapshot.data!;
        if (!manualInputEnabled) lastFrequency = frequency;
        return Column(
          children: [
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
                manualInputEnabled = !manualInputEnabled;
              },
              child: Text("Enable Manual Input"),
            ),
          ],
        );
      },
    );
  }
}
