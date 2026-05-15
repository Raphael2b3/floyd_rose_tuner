import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/detuning_matrix_selector.dart';
import 'package:floyd_rose_tuner/components/tuning_config_selector.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_config_provider.dart';
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
        Expanded(flex: 1, child: TuningConfigSelector()),
        Expanded(flex: 2, child: DetuningMatrixSelector()),
        Expanded(
          flex: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: () async {
                  if (ref.read(selectedDetuningMatrixProvider).value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No Guitar Selected!")),
                    );
                    return;
                  }
                  if (ref.read(selectedTuningConfigProvider).value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No Tuning Selected!")),
                    );
                    return;
                  }

                  await context.router.push(const GuitarTuningSetupRoute());
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
