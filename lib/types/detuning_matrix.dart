import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ml_linalg/matrix.dart';

part 'detuning_matrix.g.dart';

@JsonSerializable()
class DetuningMatrix {
  String guitarName;
  Matrix matrix;
  late Matrix inverse;
  Map<int, List<GuitarState>> samples = {};

  DetuningMatrix({required this.guitarName, matrix, samples})
    : matrix = Matrix.fromList(matrix),
      samples = samples ?? {} {
    inverse = this.matrix.inverse();
    this.samples = samples ?? {};
    assert(inverse.sum() != 0);
  }

  DetuningMatrix._({
    required this.guitarName,
    required this.matrix,
    required this.samples,
  }) : inverse = matrix.inverse() {
    assert(inverse.sum() != 0);
  }

  /// Connect the generated [DetuningMatrixFromJson] function to the `fromJson`
  /// factory.
  factory DetuningMatrix.fromJson(Map<String, dynamic> json) =>
      _$DetuningMatrixFromJson(json);

  /// Connect the generated [DetuningMatrixToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DetuningMatrixToJson(this);

  DetuningMatrix copy({
    String? guitarName,
    Matrix? matrix,
    Map<int, List<GuitarState>>? samples,
  }) {
    return DetuningMatrix._(
      guitarName: guitarName ?? this.guitarName,
      matrix: matrix ?? this.matrix,
      samples: samples ?? this.samples,
    );
  }

  List<GuitarState> getSamplesForEffectingString(int effectingStringIndex) {
    if (!samples.containsKey(effectingStringIndex)) {
      samples[effectingStringIndex] = [
        [0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0], // TODO: variable length for now 6 string guitars
      ];
    }
    var samplesForEffectingString = samples[effectingStringIndex];
    if (samplesForEffectingString == null) {
      throw Exception(
        "Samples for effecting string index $effectingStringIndex should have been initialized but is null",
      );
    }
    for (int i = samplesForEffectingString.length; i < 2; i++) {
      samplesForEffectingString.add([0, 0, 0, 0, 0, 0]); // TODO: variable length for now 6 string guitars
    }

    return samplesForEffectingString;
  }
}
