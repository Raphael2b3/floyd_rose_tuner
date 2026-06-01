import 'package:floyd_rose_tuner/types/string_measure_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'string_measure_state_provider.g.dart';


@Riverpod(keepAlive: true)
class StringMeasureStateNotifier
    extends _$StringMeasureStateNotifier {
  @override
  StringMeasureState build() {
    return StringMeasureState(
      currentStringIndex: 0,
      manualDetection: false,
    );
  }

  set stringMeasureState(StringMeasureState stringMeasureState) {
    state = stringMeasureState;
  }

  set currentStringIndex(int i) => state = state.copy(currentStringIndex: i);

  int selectNextString({int numberOfStrings = 6}) {
    int nextIndex = (state.currentStringIndex + 1) % numberOfStrings;
    currentStringIndex = nextIndex;
    return nextIndex;
  }

  int selectPreviousString({int numberOfStrings = 6}) {
    int prevIndex = (state.currentStringIndex - 1) % numberOfStrings;
    state = state.copy(currentStringIndex: prevIndex);
    return prevIndex;
  }

  void selectFirstString() {
    state = state.copy(currentStringIndex: 0);
  }
}
