import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'guitar_configuration.g.dart';

@JsonSerializable()
class GuitarConfiguration {
  String name;
  List<List<num>> coefficients;

  GuitarConfiguration({required this.name, coefficients}) : coefficients = coefficients ?? [];
  /// Connect the generated [GuitarConfigurationFromJson] function to the `fromJson`
  /// factory.
  factory GuitarConfiguration.fromJson(Map<String, dynamic> json) => _$GuitarConfigurationFromJson(json);

  /// Connect the generated [GuitarConfigurationToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$GuitarConfigurationToJson(this);

}
