import 'package:floyd_rose_tuner/provider/frequency_stream_provider.dart';
import 'package:floyd_rose_tuner/utils/frequency_to_note.dart';
import 'package:floyd_rose_tuner/utils/random_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TunerSlider extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref){
    var frequencyStream = ref.watch(frequencyStreamProvider);
    return StreamBuilder(
      stream: frequencyStream.value,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (!snapshot.hasData) return const Text("No Data");
        var frequency = snapshot.data!;
        var (noteName, centDistance) = getNearestNoteAndCentDistance(frequency);

        return Column(
        children: [
          Text("$noteName, $frequency Hz, Cent Distance: ${centDistance.toStringAsFixed(2)}"),
          Slider(
              label: "1",
              year2023: false,
              value: centDistance,
              max: 100,
              min: -100,
              onChanged: (d) {
                print(d);
              },
          ),

        ],
      );}
    );
  }
}
