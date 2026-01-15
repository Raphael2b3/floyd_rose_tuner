import 'package:json_annotation/json_annotation.dart';
import 'package:ml_linalg/matrix.dart';

part 'detuning_matrix.g.dart';

@JsonSerializable()
class DetuningMatrix {
  String guitarName;
  Matrix matrix;
  late Matrix inverse;

  DetuningMatrix({required this.guitarName, matrix})
    : matrix = Matrix.fromList(matrix) {
    inverse = this.matrix.inverse();
  }

  /// Connect the generated [DetuningMatrixFromJson] function to the `fromJson`
  /// factory.
  factory DetuningMatrix.fromJson(Map<String, dynamic> json) =>
      _$DetuningMatrixFromJson(json);

  /// Connect the generated [DetuningMatrixToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DetuningMatrixToJson(this);
}
