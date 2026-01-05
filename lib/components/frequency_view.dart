
import 'package:floyd_rose_tuner/provider/frequency_stream_provider.dart';
import 'package:floyd_rose_tuner/utils/frequency_to_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FrequencyView extends ConsumerWidget {
  const FrequencyView({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref){
    var frequencyStream = ref.watch(frequencyStreamProvider);
     return StreamBuilder(
          stream: frequencyStream.value,
          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
            if (!snapshot.hasData) return const Text("No Data");
            var frequency = snapshot.data!;

            var (noteName, centDistance) = getNearestNoteAndCentDistance(frequency);
            //print( "$frequency Hz is $noteName, $centDistance Cents");
            return Column(
            children: [
              Text(noteName, style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),),
              Text("${frequency.toStringAsFixed(2)} Hz | ${centDistance.toStringAsFixed(2)} Cents"),
              Slider(
                  label: "1",
                  year2023: false,
                  value: centDistance,
                  max: 100,
                  min: -100,
                onChanged: (e){},
              ),
            ],
          );}
        );
  }
}
