
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:async/async.dart';
import 'package:floyd_rose_tuner/provider/smoothed_frequency_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/volume_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/volume_threshold_provider.dart';
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'guitar_state_measure_state_provider.g.dart';

class GuitarStateMeasureState {
  final List<int> stringStates;

  GuitarStateMeasureState(this.stringStates);

}
@riverpod
class GuitarStateMeasureStateNotifier extends _$GuitarStateMeasureStateNotifier {
  @override
  List build()   {
    // TODO implement a view that shows which strings are measured/tuned
    // you should be able to navigate throgh a spinnable tab navigation to select which string to tune
    //
    return [];
  }

  void setGuitarStateMeasureState(double frequency) {
  }
}
 