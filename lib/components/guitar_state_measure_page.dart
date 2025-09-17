import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/guitar_behaviour_matrix_selector.dart';
import 'package:floyd_rose_tuner/components/tuner_slider.dart';
import 'package:floyd_rose_tuner/components/tuning_configuration_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

@RoutePage()
class GuitarStateMeasurePage extends ConsumerStatefulWidget {
  const GuitarStateMeasurePage({super.key});

  @override
  ConsumerState<GuitarStateMeasurePage> createState() => _GuitarStateMeasurePageState();
}

class _GuitarStateMeasurePageState extends ConsumerState<GuitarStateMeasurePage> {
  int currentString = 1;
  static const int MAX_NUMBER_OF_STRINGS = 6;
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
                Text("Guitar Measuring"),
                Text("Measure your $currentString. string"),
                TunerSlider(),
                TextField(
                  controller: TextEditingController(
                    text: "sass"
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    OutlinedButton(onPressed: () {
                      if (currentString > 1) {
                        setState(() {
                          currentString--;
                        });
                      }else {
                        context.router.pop();
                      }
                    }, child: Text("Back")),

                    OutlinedButton(onPressed: () {
                      if (currentString < MAX_NUMBER_OF_STRINGS) {
                        setState(() {
                          currentString++;
                        });
                      }
                    }, child: Text("Next")),
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
