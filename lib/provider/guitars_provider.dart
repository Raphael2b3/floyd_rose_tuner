import 'dart:convert';

import 'package:floyd_rose_tuner/utils/floyd_rose_delta_frequencies.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../types/guitar.dart';

part 'guitars_provider.g.dart';

@Riverpod(keepAlive: true)
class GuitarsNotifier extends _$GuitarsNotifier {
  List<Guitar> guitars = [];

  @override
  Future<List<Guitar>> build() async {
    guitars =
        await _loadFromLocalStorage() ??
        [
          Guitar(
            guitarName: "My New Guitar",
            //Matrix from paper
            matrix: Matrix.fromList(exampleMatrix),
          ),
        ];
    return guitars;
  }

  static const _storageKey = 'detuning_matrices';

  Future<List<Guitar>?> _loadFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null) return null;

    final decoded = json.decode(jsonString) as List<dynamic>;
    print(decoded);
    return decoded
        .map((e) => Guitar.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Save DetuningMatrice to SharedPreferences
  Future<void> _saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(guitars);
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> saveOverriding(Guitar guitar) async {
    // keep custom list in-memory and set the current state
    guitars.removeWhere((c) => c.guitarName == guitar.guitarName);
    guitars.add(guitar);
    state = AsyncValue.data([...guitars]);
    await _saveToLocalStorage();
  }

  Future<void> remove(String guitarName) async {
    guitars.removeWhere((c) => c.guitarName == guitarName);
    state = AsyncValue.data([...guitars]);
    // if the removed one is currently selected, fall back to default selectedIndex
    await _saveToLocalStorage();
  }

  void tryChangeName(String oldName, String newName) {
    int index = guitars.indexWhere((c) => c.guitarName == oldName);
    if (index != -1) {
      Guitar updatedMatrix = guitars[index].copy(guitarName: newName);
      guitars[index] = updatedMatrix;
      state = AsyncValue.data([...guitars]);
      _saveToLocalStorage();
    }
  }
}
