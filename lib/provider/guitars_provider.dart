import 'dart:convert';

import 'package:floyd_rose_tuner/provider/selected_guitar_provider.dart';
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
            matrix: Matrix.fromList(<List<double>>[
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
            ]),
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

  Future<void> saveOverriding(
    Guitar guitar,
  ) async {
    // keep custom list in-memory and set the current state
    guitars.removeWhere(
      (c) => c.guitarName == guitar.guitarName,
    );
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
      Guitar updatedMatrix = guitars[index].copy(
        guitarName: newName,
      );
      guitars[index] = updatedMatrix;
      state = AsyncValue.data([...guitars]);
      _saveToLocalStorage();
    }
  }
}
