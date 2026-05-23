import 'package:floyd_rose_tuner/components/frequency_view.dart';
import 'package:floyd_rose_tuner/provider/string_measure_state_provider.dart';
import 'package:floyd_rose_tuner/types/string_measure_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'frequency_detector_view.dart';
// We subclass ConsumerStatefulWidget instead of StatefulWidget

class GuitarStateMeasureView extends ConsumerWidget {
  const GuitarStateMeasureView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
        StringMeasureState stringMeasureState = ref.watch(
      stringMeasureStateProvider,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!stringMeasureState.manualDetection) FrequencyView(),
        FrequencyDetectorView(),
      ],
    );
  }
}
