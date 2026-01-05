
import 'package:floyd_rose_tuner/provider/volume_stream_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VolumeView extends ConsumerWidget {
  const VolumeView({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref){
    var volumeStream = ref.watch(volumeStreamProvider);
    return StreamBuilder(
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
        );
  }
}
