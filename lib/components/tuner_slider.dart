
import 'package:floyd_rose_tuner/provider/frequency_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/volume_stream_provider.dart';
import 'package:floyd_rose_tuner/utils/frequency_to_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TunerSlider extends ConsumerWidget {
  const TunerSlider({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref){
    var frequencyStream = ref.watch(frequencyStreamProvider);
    var volumeStream = ref .watch(volumeStreamProvider);
    return Column(
      children: [
        StreamBuilder(
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
        ),
        StreamBuilder(
            stream: volumeStream.value,
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              if (!snapshot.hasData) return const Text("No Data");
              var volume = snapshot.data!;
              print("Volume: $volume");

              return Column(
                children: [
                  Text("Volume", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),),
                  Text(volume.toStringAsFixed(2)),
                  Slider(
                    label: "1",
                    year2023: false,
                    value: volume,
                    max: 20,
                    min: -20,
                    onChanged: (d) {
                      print(d);
                    },
                  ),

                ],
              );}
        ),

      ],
    );
  }
}
