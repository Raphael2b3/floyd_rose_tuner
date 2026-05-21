import 'package:floyd_rose_tuner/provider/guitar_state_provider.dart';
import 'package:floyd_rose_tuner/types/calibration_state.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calibration_state_provider.g.dart';

@riverpod
class CalibrationStateNotifier
    extends _$CalibrationStateNotifier {
  @override
  CalibrationState build() {
    return CalibrationState(
      currentEffectingStringIndex: 0,
      currentSampleIndex: 0,
    );
  }

  void set(CalibrationState calibrationState) {
    state = calibrationState;
    ref.notifyListeners();
  }

  set currentEffectingStringIndex(int index) {
    state = state.copy(
      currentEffectingStringIndex: index,
      currentSampleIndex: 0,
    );

    ref.notifyListeners();
  }

  set currentSampleIndex(int index) {
    state = state.copy(currentSampleIndex: index);
    ref.notifyListeners();
  }
}
