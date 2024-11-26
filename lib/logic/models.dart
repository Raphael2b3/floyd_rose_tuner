class Template {
  String name;
  List<int> goalNotes;

  Template({required this.name, goalNotes}) : goalNotes = goalNotes ?? [];

  // Convert a Template to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'goalNotes': goalNotes,
    };
  }

  // Create a Template from JSON
  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      name: json['name'],
      goalNotes: List<int>.from(json['goalNotes'] ?? []),
    );
  }
}

class Configuration extends Template {
  List<List<double>> coefficients = [[]];

  Configuration({required super.name, coefficients})
      : coefficients = coefficients ?? [[]];

  // Convert a Configuration to JSON
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'coefficients': coefficients,
    };
  }

  // Create a Configuration from JSON
  factory Configuration.fromJson(Map<String, dynamic> json) {
    return Configuration(
      name: json['name'],
      coefficients: (json['coefficients'] as List<dynamic>?)
              ?.map((row) => List<double>.from(row))
              .toList() ??
          [[]],
    );
  }
}

class TuningInput extends Configuration {
  List<double> currentTuning = [];
  TuningInput({required super.name});
}
