import 'dart:convert';

import 'package:floyd_rose_tuner/types/tuning.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tunings_provider.g.dart';

@riverpod
class TuningsNotifier extends _$TuningsNotifier {
  List<Tuning> defaultTuning = [
    Tuning(
      name: 'Standard E',
      goalNotes: ["E2", "A2", "D3", "G3", "B3", "E4"],
    ),
    Tuning(
      name: 'Drop D',
      goalNotes: ["D2", "A2", "D3", "G3", "B3", "E4"],
    ),
    Tuning(
      name: 'DADGAD',
      goalNotes: ["D2", "A2", "D3", "G3", "A3", "D4"],
    ),
    Tuning(
      name: 'Open G',
      goalNotes: ["D2", "G2", "D3", "G3", "B3", "D4"],
    ),
    Tuning(
      name: 'Half Step Down',
      goalNotes: ["Eb2", "Ab2", "Db3", "Gb3", "Bb3", "Eb4"],
    ),
    Tuning(
      name: 'Whole Step Down',
      goalNotes: ["D2", "G2", "C3", "F3", "A3", "D4"],
    ),
    Tuning(
      name: 'Drop C',
      goalNotes: ["C2", "G2", "C3", "F3", "A3", "D4"],
    ),
    Tuning(
      name: 'Drop B',
      goalNotes: ["B1", "Gb2", "B2", "E3", "Ab3", "Db4"],
    ),
  ];
  List<Tuning> customTuning = [];

  int selectedIndex = 0;

  @override
  Future<List<Tuning>> build() async {
    customTuning = await _loadFromLocalStorage() ?? [];

    return defaultTuning + customTuning;
  }

  static const _storageKey = 'tuning_configs';

  // Load Tuning from SharedPreferences
  Future<List<Tuning>?> _loadFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      return json.decode(jsonString) as List<Tuning>;
    }
    return null;
  }

  // Save Tuning to SharedPreferences
  Future<void> _saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(customTuning);
    await prefs.setString(_storageKey, jsonString);
  }

  // Add a new config
  Future<void> add(Tuning config) async {
    // keep custom list in-memory and set the current state
    customTuning.removeWhere((c) => c.name == config.name);
    customTuning.add(config);
    state = AsyncValue.data([...defaultTuning, ...customTuning]);
    await _saveToLocalStorage();
  }

  // Remove a config by name
  Future<void> remove(String name) async {
    // remove from custom list
    customTuning.removeWhere((c) => c.name == name);
    state = AsyncValue.data([...defaultTuning, ...customTuning]);
    // if the removed one is currently selected, fall back to default selectedIndex
    await _saveToLocalStorage();
  }
}
