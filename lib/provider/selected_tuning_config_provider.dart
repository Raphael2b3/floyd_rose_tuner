import 'package:floyd_rose_tuner/provider/tuning_configs_provider.dart';
import 'package:floyd_rose_tuner/types/tuning_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_tuning_config_provider.g.dart';

@riverpod
class SelectedTuningConfigNotifier extends _$SelectedTuningConfigNotifier {
  @override
  Future<TuningConfig> build() async {
    List<TuningConfig> tuningConfigs = await ref.watch(tuningConfigsProvider.future);
    return tuningConfigs[0];
  }

  Future<void> selectTuningConfig(TuningConfig selected) async {
    state = AsyncValue.data(selected);
  }
}
