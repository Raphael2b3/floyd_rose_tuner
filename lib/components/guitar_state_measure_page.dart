import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/frequency_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

@RoutePage()
class GuitarStateMeasurePage extends ConsumerStatefulWidget {
  const GuitarStateMeasurePage({super.key});

  @override
  ConsumerState<GuitarStateMeasurePage> createState() =>
      _GuitarStateMeasurePageState();
}

class _GuitarStateMeasurePageState
    extends ConsumerState<GuitarStateMeasurePage> {
  int currentString = 1;
  static const int MAX_NUMBER_OF_STRINGS = 6;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Measure String Nr.:"),
          Text(currentString.toString(), style: TextStyle(fontSize: 48)),
          FrequencyView(),
          TextField(controller: TextEditingController(text: "sass")),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  if (currentString > 1) {
                    setState(() {
                      currentString--;
                    });
                  } else {
                    context.router.pop();
                  }
                },
                child: Text("Back"),
              ),
              if (currentString < MAX_NUMBER_OF_STRINGS)
                OutlinedButton(
                  onPressed: () {
                    if (currentString < MAX_NUMBER_OF_STRINGS) {
                      setState(() {
                        currentString++;
                      });
                    }
                  },
                  child: Text("Next"),
                )
              else
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
    );
  }
}
