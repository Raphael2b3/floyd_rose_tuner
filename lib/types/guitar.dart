import 'package:floyd_rose_tuner/types/guitar_state.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:statistics/statistics.dart';

part 'guitar.g.dart';

@JsonSerializable()
class Guitar {
  String guitarName;
  Matrix matrix;
  late Matrix inverse;

  Map<int, List<GuitarState>> samples = {};

  Guitar({
    required this.guitarName,
    required this.matrix,
    Map<int, List<GuitarState>>? samples,
  }) : samples = samples ?? {} {
    inverse = matrix.inverse();
    assert(samples == null || samples.length == 6);
    this.samples =
        samples ??
        {
          0: [GuitarState(), GuitarState()],
          1: [GuitarState(), GuitarState()],
          2: [GuitarState(), GuitarState()],
          3: [GuitarState(), GuitarState()],
          4: [GuitarState(), GuitarState()],
          5: [GuitarState(), GuitarState()],
        };

    assert(inverse.sum() != 0);
  }

  Guitar._({
    required this.guitarName,
    required this.matrix,
    required this.samples,
  }) : inverse = matrix.inverse() {
    assert(inverse.sum() != 0);
  }

  /// Connect the generated [GuitarFromJson] function to the `fromJson`
  /// factory.
  factory Guitar.fromJson(Map<String, dynamic> json) => _$GuitarFromJson(json);

  /// Connect the generated [GuitarToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$GuitarToJson(this);

  Guitar copy({
    String? guitarName,
    Matrix? matrix,
    Map<int, List<GuitarState>>? samples,
  }) {
    assert(samples == null || samples.length == 6);
    return Guitar._(
      guitarName: guitarName ?? this.guitarName,
      matrix: matrix ?? this.matrix,
      samples: samples ?? this.samples,
    );
  }

  List<GuitarState> getSamplesForEffectingString(int effectingStringIndex) {
    if (!samples.containsKey(effectingStringIndex)) {
      samples[effectingStringIndex] = [GuitarState(), GuitarState()];
    }
    List<GuitarState>? samplesForEffectingString =
        samples[effectingStringIndex];
    if (samplesForEffectingString == null) {
      throw Exception(
        "Samples for effecting string index $effectingStringIndex should have been initialized but is null",
      );
    }
    for (int i = samplesForEffectingString.length; i < 2; i++) {
      samplesForEffectingString.add(GuitarState());
    }

    return samplesForEffectingString.copy();
  }

  List<bool> getValidationForEffectingString(int effectingStringIndex) {
    return getSamplesForEffectingString(
      effectingStringIndex,
    ).map((e) => e.isValid).asList;
  }

  bool samplesForEffectingStringAreValid(int currentEffectingStringIndex) {
    return getValidationForEffectingString(
      currentEffectingStringIndex,
    ).allEquals(true);
  }

  List<bool> get effectingStringValidation => samples.entries
      .map((e) => getValidationForEffectingString(e.key).allEquals(true))
      .asList;

  List<bool> get validation => samples.entries
      .map((e) => samplesForEffectingStringAreValid(e.key))
      .asList;

  bool get isValid => validation.allEquals(true);
}
