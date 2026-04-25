import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/detuning_matrix_selector.dart';
import 'package:floyd_rose_tuner/components/tuning_config_selector.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:flutter/material.dart';

@RoutePage()
class FloydRoseTunerSetupPage extends StatefulWidget {
  const FloydRoseTunerSetupPage({super.key});

  @override
  State<FloydRoseTunerSetupPage> createState() =>
      _FloydRoseTunerSetupPageState();
}

class _FloydRoseTunerSetupPageState extends State<FloydRoseTunerSetupPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TuningConfigSelector(),
        DetuningMatrixSelector(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            FilledButton(
              onPressed: () async {
                await context.router.push(
                  const GuitarTuningRoute(),
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
