import 'package:floyd_rose_tuner/provider/frequency_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/smoothed_frequency_stream_provider.dart';
import 'package:floyd_rose_tuner/utils/frequency_to_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FrequencyView extends ConsumerWidget {
  const FrequencyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frequencyStreamAsync = ref.watch(frequencyStreamProvider);
    final Stream<double>? frequencyStream = frequencyStreamAsync.value;
    return StreamBuilder<double>(
      stream: frequencyStream,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (!snapshot.hasData) return const Text("No Data");
        var frequency = snapshot.data!;
        late var noteName, centDistance;
        if (frequency <= 0) {
          noteName = "--";
          centDistance = 0.0;
          frequency = 0.0;
        } else {
          (noteName, centDistance) = getNearestNoteAndCentDistance(frequency);
        }
        //print( "$frequency Hz is $noteName, $centDistance Cents");
        return Column(
          children: [
            Text(
              noteName,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Text(
              "${frequency.toStringAsFixed(2)} Hz | ${centDistance.toStringAsFixed(2)} Cents",
            ),
            Slider(
              label: "1",
              year2023: false,
              value: centDistance,
              max: 100,
              min: -100,
              activeColor: Theme.of(context).colorScheme.secondaryContainer,
              thumbColor: Theme.of(context).colorScheme.primary,
              onChanged: (e) {},
            ),
          ],
        );
      },
    );
  }
}
