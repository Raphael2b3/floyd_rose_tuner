import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/guitar_behaviour_matrix_selector.dart';
import 'package:floyd_rose_tuner/components/tuning_configuration_selector.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:flutter/material.dart';
import 'package:floyd_rose_tuner/types/tuning_configuration.dart';

@RoutePage()
class FloydRoseTunerSetupPage extends StatefulWidget {
  const FloydRoseTunerSetupPage({super.key});

  @override
  State<FloydRoseTunerSetupPage> createState() => _FloydRoseTunerSetupPageState();
}

class _FloydRoseTunerSetupPageState extends State<FloydRoseTunerSetupPage> {
  late TuningConfiguration _selected;

  @override
  void initState() {
    super.initState();
    _selected = TuningConfiguration(
      name: 'Standard E',
      goalNotes: ["E2", "A2", "D3", "G3", "B3", "E4"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TuningConfigurationSelector(
          current: _selected,
          onChanged: (cfg) => setState(() => _selected = cfg),
        ),
        GuitarBehaviourMatrixSelector(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton(
              onPressed: () async {
                print("test3");
                var state = await context.router.push(
                  const GuitarStateMeasureRoute(),
                );
                print(
                  "Returned from GuitarStateMeasureRoute with state $state",
                );
              },
              child: Text("Start Tuning"),
            ),
          ],
        ),
      ],
    );
  }
}
