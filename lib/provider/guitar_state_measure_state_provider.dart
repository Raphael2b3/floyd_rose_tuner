import 'package:floyd_rose_tuner/types/guitare_state_measure_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'guitar_state_measure_state_provider.g.dart';

@riverpod
class GuitarStateMeasureStateNotifier
    extends _$GuitarStateMeasureStateNotifier {
  @override
  GuitarStateMeasureState build() {
    return GuitarStateMeasureState(
      currentStringIndex: 0,
      manualDetection: false,
    );
  }
  set guitarStateMeasureState(GuitarStateMeasureState guitarStateMeasureState) {
    state = guitarStateMeasureState;
  }

  int selectNextString(int numberOfStrings) {
    int nextIndex = (state.currentStringIndex + 1) % numberOfStrings;
    state = state.copy(currentStringIndex: nextIndex);
    return nextIndex;
  }

  int selectPreviousString(int numberOfStrings) {
    int prevIndex = (state.currentStringIndex - 1) % numberOfStrings;
    state = state.copy(currentStringIndex: prevIndex);
    return prevIndex;
  }

  void selectFirstString() {
    state = state.copy(currentStringIndex: 0);
  }
}
