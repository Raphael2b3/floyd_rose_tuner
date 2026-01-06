import 'dart:convert';

import 'package:floyd_rose_tuner/types/tuning_configuration.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'tuning_configuration_provider.g.dart';




@riverpod
class TuningConfigurationsNotifier extends _$TuningConfigurationsNotifier {
  List<TuningConfiguration> defaultTuningConfigurations = [
    TuningConfiguration(
        name: 'Standard E', goalNotes: ["E2", "A2", "D3", "G3", "B3", "E4"]),
    TuningConfiguration(
        name: 'Drop D', goalNotes: ["D2", "A2", "D3", "G3", "B3", "E4"]),
    TuningConfiguration(
        name: 'DADGAD', goalNotes: ["D2", "A2", "D3", "G3", "A3", "D4"]),
    TuningConfiguration(
        name: 'Open G', goalNotes: ["D2", "G2", "D3", "G3", "B3", "D4"]),
    TuningConfiguration(
        name: 'Half Step Down',
        goalNotes: ["Eb2", "Ab2", "Db3", "Gb3", "Bb3", "Eb4"]),
    TuningConfiguration(
        name: 'Whole Step Down', goalNotes: ["D2", "G2", "C3", "F3", "A3", "D4"]),
    TuningConfiguration(
        name: 'Drop C', goalNotes: ["C2", "G2", "C3", "F3", "A3", "D4"]),
    TuningConfiguration(
        name: 'Drop B', goalNotes: ["B1", "Gb2", "B2", "E3", "Ab3", "Db4"]),
  ];
  List<TuningConfiguration> customTuningConfigurations = [  ];

  int selectedIndex = 0;
  @override
  TuningConfiguration build() {
    _loadFromLocalStorage();
    return defaultTuningConfigurations[selectedIndex];
    // Initialize with empty lists
  }

  static const _storageKey = 'tuning_configurations';

  // Load TuningConfiguration from SharedPreferences
  Future<void> _loadFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      // assign loaded configuration to state
      state = TuningConfiguration.fromJson(jsonData);
    }
  }

  // Save TuningConfiguration to SharedPreferences
  Future<void> _saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(state.toJson());
    await prefs.setString(_storageKey, jsonString);
  }


  // Add a new configuration
  Future<void> addConfiguration(TuningConfiguration configuration) async {
    // keep custom list in-memory and set the current state
    customTuningConfigurations.removeWhere((c) => c.name == configuration.name);
    customTuningConfigurations.add(configuration);
    state = configuration;
    await _saveToLocalStorage();
  }

  // Remove a configuration by name
  Future<void> removeConfiguration(String name) async {
    // remove from custom list
    customTuningConfigurations.removeWhere((c) => c.name == name);
    // if the removed one is currently selected, fall back to default selectedIndex
    if (state.name == name) {
      state = defaultTuningConfigurations.isNotEmpty
          ? defaultTuningConfigurations[selectedIndex]
          : TuningConfiguration(name: 'Default', goalNotes: []);
      await _saveToLocalStorage();
    }
  }


}
