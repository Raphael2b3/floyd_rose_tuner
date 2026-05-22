import "package:ml_linalg/matrix.dart";
import "package:ml_linalg/vector.dart";

const exampleMatrix = [
  [1.0, -0.17081316, -0.21073616, -0.43013191, -0.31517285, -0.21696815],
  [-0.13151204, 1.0, -0.17126097, -0.37112772, -0.27299015, -0.18307001],
  [-0.07967868, -0.09513059, 1.0, -0.24435172, -0.17642330, -0.12374466],
  [-0.08285579, -0.09088310, -0.11291342, 1.0, -0.17988537, -0.13078740],
  [-0.03920727, -0.04186852, -0.05205339, -0.12051330, 1.0, -0.06824934],
  [-0.00887611, -0.00678739, -0.00973759, -0.02198811, -0.01723553, 1.0],
];

List<double> floydRoseDeltaFrequencies(
  // TODO Increase precision
  Matrix inverseMatrix,
  Vector guitarState,
  Vector goalFrequencies,
) {
  final deltaVector = goalFrequencies - guitarState;
  final result = inverseMatrix * deltaVector;
  return result.asFlattenedList;
}

List<num> predictAbsolutGoalFrequencies(
  Vector guitarState,
  Vector delta,
  Matrix matrix,
) {
  List<num> out = [];
  for (int N = 0; N < 6; N++) {
    double s = 0;
    for (int i = 0; i <= N; i++) {
      s += delta[i] * matrix.elementAt(N).elementAt(i);
    }
    out.add(guitarState[N] + s);
  }
  return out;
}
