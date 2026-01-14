import "package:ml_linalg/matrix.dart";
import "package:ml_linalg/vector.dart";

List<double> floydRoseDeltaFrequencies(// TODO Increase precision
  Matrix detuningMatrix,
  Vector guitarState,
  Vector goalFrequencies,
) {
  final inverseMatrix = detuningMatrix.inverse();
  final guitarStateVector = guitarState;
  final goalFrequenciesVector = goalFrequencies;
  final deltaVector = goalFrequenciesVector-guitarStateVector;
  final result = inverseMatrix * deltaVector;
  return result.asFlattenedList;
}
