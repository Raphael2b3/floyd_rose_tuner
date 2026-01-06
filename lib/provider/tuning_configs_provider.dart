import 'dart:convert';

import 'package:floyd_rose_tuner/types/tuning_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tuning_configs_provider.g.dart';

@riverpod
class TuningConfigsNotifier extends _$TuningConfigsNotifier {
  List<TuningConfig> defaultTuningConfig = [
    TuningConfig(
      name: 'Standard E',
      goalNotes: ["E2", "A2", "D3", "G3", "B3", "E4"],
    ),
    TuningConfig(
      name: 'Drop D',
      goalNotes: ["D2", "A2", "D3", "G3", "B3", "E4"],
    ),
    TuningConfig(
      name: 'DADGAD',
      goalNotes: ["D2", "A2", "D3", "G3", "A3", "D4"],
    ),
    TuningConfig(
      name: 'Open G',
      goalNotes: ["D2", "G2", "D3", "G3", "B3", "D4"],
    ),
    TuningConfig(
      name: 'Half Step Down',
      goalNotes: ["Eb2", "Ab2", "Db3", "Gb3", "Bb3", "Eb4"],
    ),
    TuningConfig(
      name: 'Whole Step Down',
      goalNotes: ["D2", "G2", "C3", "F3", "A3", "D4"],
    ),
    TuningConfig(
      name: 'Drop C',
      goalNotes: ["C2", "G2", "C3", "F3", "A3", "D4"],
    ),
    TuningConfig(
      name: 'Drop B',
      goalNotes: ["B1", "Gb2", "B2", "E3", "Ab3", "Db4"],
    ),
  ];
  List<TuningConfig> customTuningConfig = [];

  int selectedIndex = 0;

  @override
  Future<List<TuningConfig>> build() async {
    customTuningConfig = await _loadFromLocalStorage() ?? [];

    return defaultTuningConfig + customTuningConfig;
  }

  static const _storageKey = 'tuning_configs';

  // Load TuningConfig from SharedPreferences
  Future<List<TuningConfig>?> _loadFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      return json.decode(jsonString) as List<TuningConfig>;
    }
    return null;
  }

  // Save TuningConfig to SharedPreferences
  Future<void> _saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(customTuningConfig);
    await prefs.setString(_storageKey, jsonString);
  }

  // Add a new config
  Future<void> addConfig(TuningConfig config) async {
    // keep custom list in-memory and set the current state
    customTuningConfig.removeWhere((c) => c.name == config.name);
    customTuningConfig.add(config);
    state = AsyncValue.data([...defaultTuningConfig, ...customTuningConfig]);
    await _saveToLocalStorage();
  }

  // Remove a config by name
  Future<void> removeConfig(String name) async {
    // remove from custom list
    customTuningConfig.removeWhere((c) => c.name == name);
    state = AsyncValue.data([...defaultTuningConfig, ...customTuningConfig]);
    // if the removed one is currently selected, fall back to default selectedIndex
    await _saveToLocalStorage();
  }
}
