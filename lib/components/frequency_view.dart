import 'package:floyd_rose_tuner/provider/smoothed_frequency_stream_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FrequencyView extends ConsumerWidget {
  const FrequencyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frequencyStreamAsync = ref.watch(smoothedFrequencyStreamProvider);
    final Stream<double>? frequencyStream = frequencyStreamAsync.value;
    return StreamBuilder<double>(
      stream: frequencyStream,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (!snapshot.hasData) return const Text("No Data");
        double? frequency = snapshot.data;
        if (frequency == null) {
          return const Text("No Data");
        }
        if (frequency <= 0) {
          frequency = 0.0;
        }
        //print( "$frequency Hz is $noteName, $centDistance Cents");
        return Text(
          "${frequency.toStringAsFixed(2)} Hz ",
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
