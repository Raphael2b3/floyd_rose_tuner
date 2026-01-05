import 'package:floyd_rose_tuner/types/tuning_configuration.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'tuning_configuration_provider.g.dart';
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

TuningConfiguration? selectedTuningConfiguration =
    defaultTuningConfigurations[0];



@riverpod
class TuningConfigurationsNotifier extends _$TuningConfigurationsNotifier<TuningConfiguration> {
  @override
  TuningConfigurations build() {
    _loadFromLocalStorage();
    return TuningConfigurations(configurations: [], templates: []);
    // Initialize with empty lists
  }

  static const _storageKey = 'tuning_configurations';

  // Load TuningConfigurations from SharedPreferences
  Future<void> _loadFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      state = TuningConfigurations.fromJson(jsonData);
    }
  }

  // Save TuningConfigurations to SharedPreferences
  Future<void> _saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(state.toJson());
    await prefs.setString(_storageKey, jsonString);
  }

  // Add a new template
  Future<void> addTemplate(Template template) async {
    state = TuningConfigurations(
      templates: [...state.templates, template],
      configurations: state.configurations,
    );
    await _saveToLocalStorage();
  }

  // Remove a template by name
  Future<void> removeTemplate(String name) async {
    state = TuningConfigurations(
      templates: state.templates.where((t) => t.name != name).toList(),
      configurations: state.configurations,
    );
    await _saveToLocalStorage();
  }

  // Add a new configuration
  Future<void> addConfiguration(Configuration configuration) async {
    state = TuningConfigurations(
      templates: state.templates,
      configurations: [...state.configurations, configuration],
    );
    await _saveToLocalStorage();
  }

  // Remove a configuration by name
  Future<void> removeConfiguration(String name) async {
    state = TuningConfigurations(
      templates: state.templates,
      configurations: state.configurations.where((c) => c.name != name).toList(),
    );
    await _saveToLocalStorage();
  }

  // Clear all settings
  Future<void> clearSettings() async {
    state = TuningConfigurations(templates: [], configurations: []);
    await _saveToLocalStorage();
  }
}

// Riverpod provider for TuningConfigurations
final tuningConfigurationsProvider = NotifierProvider<TuningConfigurationsNotifier, TuningConfigurations>(
    TuningConfigurationsNotifier.new
);
