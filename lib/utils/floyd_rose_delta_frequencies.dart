import "package:ml_linalg/matrix.dart";
import "package:ml_linalg/vector.dart";

List<double> floydRoseDeltaFrequencies(
  // TODO Increase precision
  Matrix inverseDetuningMatrix,
  Vector guitarState,
  Vector goalFrequencies,
) {
  final deltaVector = goalFrequencies - guitarState;
  final result = inverseDetuningMatrix * deltaVector;
  return result.asFlattenedList;
}

List<num> predictAbsolutGoalFrequencies(
  Vector guitarState,
  Vector delta,
  Matrix detuningMatrix,
) {
  List<num> out = [];
  for (int N = 0; N < 6; N++) {
    double s = 0;
    for (int i = 0; i <= N; i++) {
      s += delta[i] * detuningMatrix.elementAt(N).elementAt(i);
    }
    out.add(guitarState[N] + s);
  }
  return out;
}
