import 'package:floyd_rose_tuner/provider/frequency_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/volume_stream_provider.dart';
import 'package:floyd_rose_tuner/utils/frequency_to_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VolumeView extends ConsumerWidget {
  const VolumeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var volumeStream = ref.watch(volumeStreamProvider);
    return StreamBuilder(
      stream: volumeStream.value,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (!snapshot.hasData) return const Text("No Data");
        var volume = snapshot.data!;
        return Column(
          children: [
            Slider(
              label: "1",
              year2023: false,
              value: volume,
              max: 100,
              min: -100,
              onChanged: (e) {},
              secondaryTrackValue: 3,
            ),
          ],
        );
      },
    );
  }
}
