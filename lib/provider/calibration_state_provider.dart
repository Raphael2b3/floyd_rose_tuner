import 'package:floyd_rose_tuner/types/calibration_state.dart';
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
  }

  set currentSampleIndex(int index) {
    state = state.copy(currentSampleIndex: index);
  }

  set stringIsChanging(bool isChanging){
    state = state.copy(stringIsChanging: isChanging);

  }
}
