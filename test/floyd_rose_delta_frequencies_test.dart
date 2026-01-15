import 'package:flutter_test/flutter_test.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';

/// ---------------------------------------------------------------------------
/// Gemeinsame Toleranz
/// ---------------------------------------------------------------------------
const double eps = 1e-4; // TODO Increase precision

/// ---------------------------------------------------------------------------
/// Helper
/// ---------------------------------------------------------------------------
Vector matrixToVector(Matrix m) {
  // Erwartung: Ergebnis ist eine Nx1-Matrix
  if (m.columnCount != 1) {
    throw ArgumentError(
      'Expected a column matrix (Nx1), got ${m.rowCount}x${m.columnCount}',
    );
  }

  return Vector.fromList(m.asFlattenedList);
}

void expectVectorCloseTo(Vector actual, Vector expected, {double tol = eps}) {
  expect(actual.length, expected.length);

  for (var i = 0; i < actual.length; i++) {
    expect(
      actual[i],
      closeTo(expected[i], tol),
      reason: 'Index $i: ${actual[i]} vs ${expected[i]}',
    );
  }
}

void expectMatrixCloseTo(Matrix actual, Matrix expected, {double tol = eps}) {
  expect(actual.rowCount, expected.rowCount);
  expect(actual.columnCount, expected.columnCount);

  final diff = actual - expected;
  for (final v in diff.asFlattenedList) {
    expect(v.abs() < tol, true);
  }
}

/// ---------------------------------------------------------------------------
/// Testdaten (zentral, unveränderlich)
/// ---------------------------------------------------------------------------
final goal = Vector.fromList([82.41, 110.00, 146.83, 196.00, 246.94, 329.63]);

final guitarState = Vector.fromList([80.0, 113.0, 142.2, 200.0, 242.4, 319.33]);

final detuningMatrix = Matrix.fromList([
  [1.0, -0.13151204, -0.07967868, -0.08285579, -0.03920727, -0.00887611],
  [-0.17081316, 1.0, -0.09513059, -0.09088310, -0.04186852, -0.00678739],
  [-0.21073616, -0.17126097, 1.0, -0.11291342, -0.05205339, -0.00973759],
  [-0.43013191, -0.37112772, -0.24435172, 1.0, -0.12051330, -0.02198811],
  [-0.31517285, -0.27299015, -0.17642330, -0.17988537, 1.0, -0.01723553],
  [-0.21696815, -0.18307001, -0.12374466, -0.13078740, -0.06824934, 1.0],
]);

/// ---------------------------------------------------------------------------
/// Tests
/// ---------------------------------------------------------------------------
void main() {
  group('Input sanity checks', () {
    test('matrix dimensions are 6x6', () {
      expect(detuningMatrix.rowCount, 6);
      expect(detuningMatrix.columnCount, 6);
    });

    test('vectors have length 6', () {
      expect(goal.length, 6);
      expect(guitarState.length, 6);
    });
    test('inverse works', () {
      final identity = detuningMatrix * detuningMatrix.inverse();

      for (var i = 0; i < identity.rowCount; i++) {
        for (var j = 0; j < identity.columnCount; j++) {
          if (i == j) {
            // Diagonale ≈ 1
            expect(identity[i][j], closeTo(1.0, eps));
          } else {
            // Nebendiagonale ≈ 0
            expect(identity[i][j], closeTo(0.0, eps));
          }
        }
      }
    });
  });

  group('Step 1: delta frequencies (goal - current)', () {
    test('rhs vector matches expected values', () {
      final rhs = goal - guitarState;

      final expectedRhs = Vector.fromList([
        2.41,
        -3.0,
        4.63,
        -4.0,
        4.54,
        10.30,
      ]);

      expectVectorCloseTo(rhs, expectedRhs);
    });
  });

  group('Step 2: matrix inversion', () {
    test('inverse matrix matches paper values', () {
      final inverse = detuningMatrix.inverse();

      final expectedInverse = Matrix.fromList([
        [
          1.18565929,
          0.27388702,
          0.17790115,
          0.16155557,
          0.08799298,
          0.01918426,
        ],
        [
          0.35590854,
          1.17812980,
          0.20367199,
          0.17942121,
          0.09678503,
          0.01875206,
        ],
        [
          0.44903285,
          0.37855111,
          1.15193210,
          0.22696042,
          0.12246603,
          0.02487328,
        ],
        [
          0.84944366,
          0.73167568,
          0.48961770,
          1.24215356,
          0.24244901,
          0.04876497,
        ],
        [
          0.71213654,
          0.61426343,
          0.40832155,
          0.36827210,
          1.12213540,
          0.04190453,
        ],
        [
          0.53767128,
          0.45956571,
          0.31033407,
          0.28357656,
          0.16025890,
          1.01991105,
        ],
      ]);

      expectMatrixCloseTo(inverse, expectedInverse);
    });
  });

  group('Step 3: solve linear system', () {
    test('delta vector is correct', () {
      final rhs = goal - guitarState;
      final delta = detuningMatrix.inverse() * rhs;

      final expectedDelta = Vector.fromList([
        2.81032384,
        -1.81878311,
        5.18431042,
        -1.24655435,
        5.81701047,
        11.45229035,
      ]);
      expectVectorCloseTo(matrixToVector(delta), expectedDelta);
    });
  });

  group('Step 4: reconstruction check', () {
    test('A * delta + guitarState equals goal', () {
      final rhs = goal - guitarState;
      final delta = detuningMatrix.inverse() * rhs;
      final reconstructed =
          matrixToVector(detuningMatrix * delta) + guitarState;

      expectVectorCloseTo(reconstructed, goal);
    });
  });

  group('Step 5: residual analysis', () {
    test('residual is near zero', () {
      final rhs = goal - guitarState;
      final delta = detuningMatrix.inverse() * rhs;

      final residual = matrixToVector(detuningMatrix * delta) - rhs;

      for (final v in residual) {
        expect(v.abs() < eps, true);
      }
    });
  });
}
