import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/guitar_behaviour_matrix_selector.dart';
import 'package:floyd_rose_tuner/components/tuner_slider.dart';
import 'package:floyd_rose_tuner/components/tuning_configuration_selector.dart';
import 'package:flutter/material.dart';

@RoutePage()
class GuitarStateMeasurePage extends StatefulWidget {
  const GuitarStateMeasurePage({super.key});

  @override
  State<GuitarStateMeasurePage> createState() => _GuitarStateMeasurePageState();
}

class _GuitarStateMeasurePageState extends State<GuitarStateMeasurePage> {
  int currentString = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox.expand(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Measure your n. string"),
                TunerSlider(),
                TextField(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    OutlinedButton(onPressed: () {}, child: Text("Back")),

                    OutlinedButton(onPressed: () {}, child: Text("Next")),
                    FilledButton(
                      onPressed: () {
                        context.router.maybePop([1, 2, 3]);
                      },
                      child: Text("Done"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
