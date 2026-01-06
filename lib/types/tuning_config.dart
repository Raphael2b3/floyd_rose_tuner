import 'package:json_annotation/json_annotation.dart';

part 'tuning_config.g.dart';

@JsonSerializable()
class TuningConfig {
  String name;
  List<String> goalNotes;

  TuningConfig({required this.name, goalNotes}) : goalNotes = goalNotes ?? [];

  /// Connect the generated [_$TuningConfigFromJson] function to the `fromJson`
  /// factory.
  factory TuningConfig.fromJson(Map<String, dynamic> json) =>
      _$TuningConfigFromJson(json);

  /// Connect the generated [_$TuningConfigToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TuningConfigToJson(this);
}
