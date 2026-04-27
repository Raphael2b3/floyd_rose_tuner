import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/provider/frequency_stream_provider.dart';
import 'package:floyd_rose_tuner/utils/frequency_to_note.dart'
    show getNearestNoteAndCentDistance;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class StandardTunerPage extends ConsumerWidget {
  const StandardTunerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frequencyStreamAsync = ref.watch(frequencyStreamProvider);
    final Stream<double>? frequencyStream = frequencyStreamAsync.value;
    return StreamBuilder<double>(
      stream: frequencyStream,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (!snapshot.hasData) return const Text("No Data");
        var frequency = snapshot.data;
        if (frequency == null) return const Text("No Data");
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              noteName,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            Text(
              "${frequency.toStringAsFixed(2)} Hz | ${centDistance.toStringAsFixed(2)} Cents",
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Slider(
                  year2023: false,
                  value: centDistance.clamp(-100.0, 100.0),
                  max: 100,
                  min: -100,
                  activeColor: Theme.of(context).colorScheme.secondaryContainer,
                  thumbColor: Theme.of(context).colorScheme.primary,
                  onChanged: (_) {},
                ),
                IgnorePointer(
                  child: Opacity(
                    opacity: 0.3,
                    child: Container(
                      width: 24,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
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
