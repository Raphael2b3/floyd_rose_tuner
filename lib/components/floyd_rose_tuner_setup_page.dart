import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/guitar_selector.dart';
import 'package:floyd_rose_tuner/components/tuning_selector.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class FloydRoseTunerSetupPage extends ConsumerWidget {
  const FloydRoseTunerSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 1, child: TuningSelector()),
        Expanded(flex: 2, child: GuitarSelector()),
        Expanded(
          flex: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: () async {
                  if (ref.read(selectedGuitarProvider).value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No Guitar Selected!")),
                    );
                    return;
                  }
                  if (ref.read(selectedTuningProvider).value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No Tuning Selected!")),
                    );
                    return;
                  }
                  ref
                      .read(guitarStateMeasureStateProvider.notifier)
                      .selectFirstString();
                  await context.router.navigate(
                    FloydRoseTunerMeasureStringRoute(),
                  );
                },
                child: Text("Start Tuning"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
