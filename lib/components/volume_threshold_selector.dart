import 'package:floyd_rose_tuner/provider/frequency_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/volume_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/volume_threshold_provider.dart';
import 'package:floyd_rose_tuner/utils/frequency_to_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VolumeThresholdSelector extends ConsumerWidget {
  const VolumeThresholdSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var volumeStream = ref.watch(volumeStreamProvider);
    return StreamBuilder(
      stream: volumeStream.value,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (!snapshot.hasData) return const Text("No Data");
        var volume = snapshot.data!;
        //print("Volume: $volume");
        var threshold = ref.watch(volumeThresholdProvider);
        var thresholdNotifier = ref.read(volumeThresholdProvider.notifier);
        return Column(
          children: [
            Row(
              spacing: 0,
              children: [
                Text("Sensitivity"),
                Expanded(
                  child: Slider(
                    label: "1",
                    year2023: false,
                    value: threshold,
                    max: 0,
                    min: -20,
                    onChanged: (e) {
                       thresholdNotifier.set(e); },
                    secondaryTrackValue: volume,

                    //activeColor: Color.fromRGBO(50, 50, 50, 0),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
