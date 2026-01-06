import 'package:floyd_rose_tuner/provider/detuning_matrices_provider.dart';
import 'package:floyd_rose_tuner/provider/tuning_configs_provider.dart';
import 'package:floyd_rose_tuner/types/detuning_matrix.dart';
import 'package:floyd_rose_tuner/types/tuning_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_detuning_matrix_provider.g.dart';

@riverpod
class SelectedDetuningMatrixNotifier extends _$SelectedDetuningMatrixNotifier {
  @override
  Future<DetuningMatrix?> build() async {
    var detuningMatrix = await ref.watch(detuningMatricesProvider.future);
    if (detuningMatrix.isEmpty) {
      return null;
    }
    return detuningMatrix[0];
  }

  Future<void> selectDetuningMatrix(DetuningMatrix selected) async {
    state = AsyncValue.data(selected);
  }
}
