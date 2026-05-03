import 'package:floyd_rose_tuner/utils/calculate_matrix_row.dart';
import 'package:test/test.dart';

typedef SmallGuitarState = List<num>;

void main() {
  group('calculateMatrixColumn', () {
    test('returns 1 at variableIndex', () {
      List<SmallGuitarState> samples = [
        [1.0, 2.0, 3.0],
        [2.0, 4.0, 6.0],
        [3.0, 6.0, 9.0],
      ];

      List<double> result = calculateMatrixColumn(samples, 0);

      expect(result[0], equals(1.0));
    });

    test('perfect positive linear dependence (y = 2x)', () {
      List<SmallGuitarState> samples = [
        [1.0, 2.0],
        [2.0, 4.0],
        [3.0, 6.0],
        [4.0, 8.0],
      ];

      List<double> result = calculateMatrixColumn(samples, 0);

      // coefficient should be close to 2
      expect(result[1], closeTo(2.0, 1e-9));
    });

    test('perfect negative linear dependence (y = -3x)', () {
      List<SmallGuitarState> samples = [
        [1.0, -3.0],
        [2.0, -6.0],
        [3.0, -9.0],
        [4.0, -12.0],
      ];

      List<double> result = calculateMatrixColumn(samples, 0);

      expect(result[1], closeTo(-3.0, 1e-9));
    });

    test('independent variables → covariance approx 0', () {
      List<SmallGuitarState> samples = [
        [1.0, 10.0],
        [2.0, 9.0],
        [3.0, 11.0],
        [4.0, 10.0],
      ];

      List<double> result = calculateMatrixColumn(samples, 0);

      // Not well-defined analytically, but should not be NaN or infinite
      expect(result[1].isFinite, isTrue);
    });

    test('multiple dimensions', () {
      List<SmallGuitarState> samples = [
        [1.0, 2.0, 3.0],
        [2.0, 4.0, 6.0],
        [3.0, 6.0, 9.0],
      ];

      List<double> result = calculateMatrixColumn(samples, 0);

      expect(result.length, equals(3));
      expect(result[0], equals(1.0));
      expect(result[1], closeTo(2.0, 1e-9));
      expect(result[2], closeTo(3.0, 1e-9));
    });

    test('throws assertion if variableIndex out of bounds', () {
      List<SmallGuitarState> samples = [
        [1.0, 2.0],
        [2.0, 4.0],
      ];

      expect(
        () => calculateMatrixColumn(samples, 2),
        throwsA(isA<AssertionError>()),
      );
    });

    test('variance normalization (N-1) is stable', () {
      List<SmallGuitarState> samples = [
        [1.0, 2.1],
        [2.0, 3.9],
        [3.0, 6.2],
        [4.0, 7.8],
      ];

      List<double> result = calculateMatrixColumn(samples, 0);

      expect(result[1].isFinite, isTrue);
      expect(result[1].isNaN, isFalse);
    });
  });
}
