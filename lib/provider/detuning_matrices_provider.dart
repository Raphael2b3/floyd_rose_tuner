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
    detuningMatrices = await _loadFromLocalStorage() ?? [];
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

  Future<void> addDetuningMatrix(DetuningMatrix detuningMatrix) async {
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
}
