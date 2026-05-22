import 'package:floyd_rose_tuner/types/guitar_state.dart';

class CalibrationState {
  final int currentEffectingStringIndex;
  final int currentSampleIndex;
  final bool stringIsChanging;
  CalibrationState({
    required this.currentEffectingStringIndex,
    required this.currentSampleIndex,
    required this.stringIsChanging,
    Map<int, List<GuitarState>>? guitarStateSamples,
  });

  CalibrationState copy({
    int? currentEffectingStringIndex,
    int? currentSampleIndex,
    bool? stringIsChanging,
  }) {
    return CalibrationState(
      currentEffectingStringIndex:
          currentEffectingStringIndex ?? this.currentEffectingStringIndex,
      currentSampleIndex: currentSampleIndex ?? this.currentSampleIndex,
      stringIsChanging: stringIsChanging ?? this.stringIsChanging,
    );
  }
}
