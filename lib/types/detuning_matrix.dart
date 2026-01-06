import 'package:json_annotation/json_annotation.dart';

part 'detuning_matrix.g.dart';

@JsonSerializable()
class DetuningMatrix {
  String guitarName;
  List<List<num>> matrix;

  DetuningMatrix({required this.guitarName, matrix}) : matrix = matrix ?? [];

  /// Connect the generated [DetuningMatrixFromJson] function to the `fromJson`
  /// factory.
  factory DetuningMatrix.fromJson(Map<String, dynamic> json) =>
      _$DetuningMatrixFromJson(json);

  /// Connect the generated [DetuningMatrixToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DetuningMatrixToJson(this);
}
