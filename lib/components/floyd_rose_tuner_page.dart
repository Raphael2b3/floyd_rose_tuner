
import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/guitar_behaviour_matrix_selector.dart';
import 'package:floyd_rose_tuner/components/tuning_configuration_selector.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:flutter/material.dart';
@RoutePage()
class FloydRoseTunerPage extends StatelessWidget {
  const FloydRoseTunerPage({super.key});

  @override
  Widget build(BuildContext context) {

    return SizedBox.expand(
      child :Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TuningConfigurationSelector(),
              GuitarBehaviourMatrixSelector(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: () async {
                      print("test3");
                      var state = await context.router.push(const GuitarStateMeasureRoute());
                      print("Returned from GuitarStateMeasureRoute with state $state");

                      },
                    child: Text("Start Tuning"),
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}
