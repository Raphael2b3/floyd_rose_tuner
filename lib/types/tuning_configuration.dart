import 'package:json_annotation/json_annotation.dart';

part 'tuning_configuration.g.dart';

@JsonSerializable()
class TuningConfiguration {
  String name;
  List<String> goalNotes;

  TuningConfiguration({required this.name, goalNotes}) : goalNotes = goalNotes ?? [];
  /// Connect the generated [_$TuningConfigurationFromJson] function to the `fromJson`
  /// factory.
  factory TuningConfiguration.fromJson(Map<String, dynamic> json) => _$TuningConfigurationFromJson(json);

  /// Connect the generated [_$TuningConfigurationToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TuningConfigurationToJson(this);

}
