
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


// Load TuningConfiguration from SharedPreferences
Future<T?> loadFromLocalStorage<T>() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString(T.toString());
  if (jsonString != null) {
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    return jsonData as T;
  }
  return null;
}

class Storageable {
  Map<String, dynamic> toJson() {
    throw UnimplementedError('toJson() must be implemented in subclasses');
  }
}
// Save TuningConfiguration to SharedPreferences
Future<void> saveToLocalStorage<T extends Storageable>(T data) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = json.encode(data.toJson());
  await prefs.setString(T.toString(), jsonString);
}


