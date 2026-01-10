import 'package:floyd_rose_tuner/provider/detected_frequency_provider.dart';
import 'package:floyd_rose_tuner/provider/selected_detuning_matrix_provider.dart';
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:async/async.dart';
import 'package:floyd_rose_tuner/provider/smoothed_frequency_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/volume_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/volume_threshold_provider.dart';
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'guitar_state_measure_state_provider.dart';

part 'guitar_state_provider.g.dart';


@Riverpod(keepAlive: true)
class GuitarStateNotifier extends _$GuitarStateNotifier {
  Map<String, List<num>> guitarStates = { };

  @override
  Future<GuitarState> build()async  {
    var detectedFrequency = await ref.watch(detectedFrequencyProvider.future);
    var currentDetuningMatrix = await ref.watch(selectedDetuningMatrixProvider.future);
    var guitarStateMeasureState = ref.read(guitarStateMeasureStateProvider);

    guitarStates[currentDetuningMatrix!.guitarName]![guitarStateMeasureState.currentStringIndex] = detectedFrequency;
    return guitarStates[currentDetuningMatrix.guitarName]!;
  }

  void setGuitarState(double frequency) {
  }
}
