import 'dart:convert';

import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../types/detuning_matrix.dart';

part 'guitar_tuning_assistant_provider.g.dart';

@Riverpod(keepAlive: true)
class GuitarTuningAssistantNotifier extends _$GuitarTuningAssistantNotifier {

  @override
  Future<List<double>> build() async {
    var matrix = await ref.watch(detuningMatricesProvider.future);
    var guitarState = await ref.watch(guitarStateProvider.future);
    var delta = 0;
    return [];
  }


}
