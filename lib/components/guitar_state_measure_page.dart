import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/frequency_view.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_navigation.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_measure_state_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_tuning_provider.dart';
import 'package:floyd_rose_tuner/types/guitar_state_measure_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'frequency_detector_view.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

@RoutePage()
class GuitarStateMeasurePage extends ConsumerWidget {
  const GuitarStateMeasurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
        GuitarStateMeasureState guitarStateMeasureState = ref.watch(
      guitarStateMeasureStateProvider,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //GuitarStateMeasureNavigation(),
        if (!guitarStateMeasureState.manualDetection) FrequencyView(),
        FrequencyDetectorView(),
      ],
    );
  }
}
