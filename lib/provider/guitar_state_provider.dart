
import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:async/async.dart';
import 'package:floyd_rose_tuner/provider/smoothed_frequency_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/volume_stream_provider.dart';
import 'package:floyd_rose_tuner/provider/volume_threshold_provider.dart';
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'guitar_state_provider.g.dart';


@riverpod
class GuitarStateNotifier extends _$GuitarStateNotifier {
  @override
  GuitarState build()   {

    return [];
  }

  void setGuitarState(double frequency) {
  }
}
