import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'guitar_behaviour_matrix.g.dart';

@JsonSerializable()
class GuitarBehaviourMatrix {
  String guitarName;
  List<List<num>> matrix;

  GuitarBehaviourMatrix({required this.guitarName, matrix}) : matrix = matrix ?? [];
  /// Connect the generated [GuitarBehaviourMatrixFromJson] function to the `fromJson`
  /// factory.
  factory GuitarBehaviourMatrix.fromJson(Map<String, dynamic> json) => _$GuitarBehaviourMatrixFromJson(json);

  /// Connect the generated [GuitarBehaviourMatrixToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$GuitarBehaviourMatrixToJson(this);

}
