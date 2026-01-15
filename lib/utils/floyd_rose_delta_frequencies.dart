import "package:ml_linalg/inverse.dart";
import "package:ml_linalg/matrix.dart";
import "package:ml_linalg/vector.dart";

List<double> floydRoseDeltaFrequencies(// TODO Increase precision
  Matrix inverseDetuningMatrix,
  Vector guitarState,
  Vector goalFrequencies,
) {
  final deltaVector = goalFrequencies-guitarState;
  final result = inverseDetuningMatrix * deltaVector;
  return result.asFlattenedList;
}
