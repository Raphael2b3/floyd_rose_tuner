import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../types/detuning_matrix.dart';

part 'detuning_matrices_provider.g.dart';

@Riverpod(keepAlive: true)
class DetuningMatricesNotifier extends _$DetuningMatricesNotifier {
  List<DetuningMatrix> detuningMatrices = [];

  @override
  Future<List<DetuningMatrix>> build() async {
    detuningMatrices =
        await _loadFromLocalStorage() ??
        [
          DetuningMatrix(
            guitarName: "My New Guitar",
            //Matrix from paper
            matrix: <List<double>>[
              [
                1.0,
                -0.13151204,
                -0.07967868,
                -0.08285579,
                -0.03920727,
                -0.00887611,
              ],
              [
                -0.17081316,
                1.0,
                -0.09513059,
                -0.09088310,
                -0.04186852,
                -0.00678739,
              ],
              [
                -0.21073616,
                -0.17126097,
                1.0,
                -0.11291342,
                -0.05205339,
                -0.00973759,
              ],
              [
                -0.43013191,
                -0.37112772,
                -0.24435172,
                1.0,
                -0.12051330,
                -0.02198811,
              ],
              [
                -0.31517285,
                -0.27299015,
                -0.17642330,
                -0.17988537,
                1.0,
                -0.01723553,
              ],
              [
                -0.21696815,
                -0.18307001,
                -0.12374466,
                -0.13078740,
                -0.06824934,
                1.0,
              ],
            ],
          ),
        ];
    return detuningMatrices;
  }

  static const _storageKey = 'detuning_matrices';

  // Load DetuningMatrice from SharedPreferences
  Future<List<DetuningMatrix>?> _loadFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      return json.decode(jsonString) as List<DetuningMatrix>;
    }
    return null;
  }

  // Save DetuningMatrice to SharedPreferences
  Future<void> _saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(detuningMatrices);
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> saveDetuningMatrixOverriding(
    DetuningMatrix detuningMatrix,
  ) async {
    // keep custom list in-memory and set the current state

    detuningMatrices.removeWhere(
      (c) => c.guitarName == detuningMatrix.guitarName,
    );
    detuningMatrices.add(detuningMatrix);
    state = AsyncValue.data([...detuningMatrices]);
    await _saveToLocalStorage();
  }

  Future<void> removeDetuningMatrix(String guitarName) async {
    detuningMatrices.removeWhere((c) => c.guitarName == guitarName);
    state = AsyncValue.data([...detuningMatrices]);
    // if the removed one is currently selected, fall back to default selectedIndex
    await _saveToLocalStorage();
  }

  void changeGuitarName(String oldName, String newName) {
    int index = detuningMatrices.indexWhere((c) => c.guitarName == oldName);
    if (index != -1) {
      DetuningMatrix updatedMatrix = detuningMatrices[index].copy(
        guitarName: newName,
      );
      detuningMatrices[index] = updatedMatrix;
      state = AsyncValue.data([...detuningMatrices]);
      _saveToLocalStorage();
    }
  }
}
