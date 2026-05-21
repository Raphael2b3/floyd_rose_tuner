import 'package:json_annotation/json_annotation.dart';

part 'tuning.g.dart';

@JsonSerializable()
class Tuning {
  String name;
  List<String> goalNotes;

  Tuning({required this.name, goalNotes}) : goalNotes = goalNotes ?? [];

  /// Connect the generated [_$TuningFromJson] function to the `fromJson`
  /// factory.
  factory Tuning.fromJson(Map<String, dynamic> json) =>
      _$TuningFromJson(json);

  /// Connect the generated [_$TuningToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TuningToJson(this);
}
