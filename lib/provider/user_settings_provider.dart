import 'dart:convert'; // For JSON encoding and decoding
import 'package:floyd_rose_tuner/types/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettings {
  List<Template> templates;
  List<Configuration> configurations;

  UserSettings({required this.configurations, required this.templates});

  // Convert UserSettings to JSON
  Map<String, dynamic> toJson() {
    return {
      'templates': templates.map((template) => template.toJson()).toList(),
      'configurations':
      configurations.map((configuration) => configuration.toJson()).toList(),
    };
  }

  // Create UserSettings from JSON
  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      templates: (json['templates'] as List<dynamic>)
          .map((template) => Template.fromJson(template))
          .toList(),
      configurations: (json['configurations'] as List<dynamic>)
          .map((configuration) => Configuration.fromJson(configuration))
          .toList(),
    );
  }

}


class UserSettingsNotifier extends Notifier<UserSettings> {
  @override
  UserSettings build() {
    _loadFromLocalStorage();
    return UserSettings(configurations: [], templates: []);
    // Initialize with empty lists
  }

  static const _storageKey = 'user_settings';

  // Load UserSettings from SharedPreferences
  Future<void> _loadFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      state = UserSettings.fromJson(jsonData);
    }
  }

  // Save UserSettings to SharedPreferences
  Future<void> _saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(state.toJson());
    await prefs.setString(_storageKey, jsonString);
  }

  // Add a new template
  Future<void> addTemplate(Template template) async {
    state = UserSettings(
      templates: [...state.templates, template],
      configurations: state.configurations,
    );
    await _saveToLocalStorage();
  }

  // Remove a template by name
  Future<void> removeTemplate(String name) async {
    state = UserSettings(
      templates: state.templates.where((t) => t.name != name).toList(),
      configurations: state.configurations,
    );
    await _saveToLocalStorage();
  }

  // Add a new configuration
  Future<void> addConfiguration(Configuration configuration) async {
    state = UserSettings(
      templates: state.templates,
      configurations: [...state.configurations, configuration],
    );
    await _saveToLocalStorage();
  }

  // Remove a configuration by name
  Future<void> removeConfiguration(String name) async {
    state = UserSettings(
      templates: state.templates,
      configurations: state.configurations.where((c) => c.name != name).toList(),
    );
    await _saveToLocalStorage();
  }

  // Clear all settings
  Future<void> clearSettings() async {
    state = UserSettings(templates: [], configurations: []);
    await _saveToLocalStorage();
  }
}

// Riverpod provider for UserSettings
final userSettingsProvider = NotifierProvider<UserSettingsNotifier, UserSettings>(
      UserSettingsNotifier.new
);
