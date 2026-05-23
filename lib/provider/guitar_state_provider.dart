import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'guitar_state_provider.g.dart';

@Riverpod(keepAlive: true)
class GuitarStateNotifier extends _$GuitarStateNotifier {
  set guitarState(GuitarState gs) {
    state = gs.copy();
  }

  void saveFrequency(double frequency, int index) {
    if (index >= 0 && index < state.length) {
      state[index] = frequency;
      state = state.copy();
    }
  }

  @override
  GuitarState build() {
    return GuitarState();
  }
}
