import 'package:floyd_rose_tuner/provider/tunings_provider.dart';
import 'package:floyd_rose_tuner/types/tuning.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_tuning_provider.g.dart';

@riverpod
class SelectedTuningNotifier extends _$SelectedTuningNotifier {
  @override
  Future<Tuning> build() async {
    List<Tuning> tunings = await ref.watch(tuningsProvider.future);
    return tunings[0];
  }

  Future<void> select(Tuning selected) async {
    state = AsyncValue.data(selected);
  }
}
