import 'dart:math';
import 'package:floyd_rose_tuner/types/guitar_state.dart';

List<double> calculateMatrixColumn(
    List<GuitarState> samples,
    int variableIndex,
    ) {
  final n = samples.length;
  assert(samples.every((s) => s.length > variableIndex));

  // Spalten extrahieren
  List<double> col(int i) => samples.map((s) => s[i].toDouble()).toList();
  double mean(List<double> xs) => xs.reduce((a, b) => a + b) / xs.length;

  final x = col(variableIndex);
  //assert(x.every((v) => v != 0));

  final meanX = mean(x);
  final dimCount = samples[0].length;
  final otherIndices = List.generate(dimCount, (i) => i).where((i) => i != variableIndex);

  // Varianz / Kovarianz für eine Spalte
  double variance(List<double> xs, double meanXs) =>
      xs.map((v) => pow(v - meanXs, 2).toDouble()).reduce((a, b) => a + b) / (n - 1);

  double covariance(List<double> ys, double meanY) =>
      Iterable.generate(n, (i) => (x[i] - meanX) * (ys[i] - meanY))
          .reduce((a, b) => a + b) /
          (n - 1);

  final varX = variance(x, meanX);

  // Koeffizient berechnen
  double coefficient(int i) {
    final y = col(i);
    final meanY = mean(y);
    final varY = variance(y, meanY);
    final covXY = covariance(y, meanY);
    assert(covXY != 0, 'covXY is zero – variables are uncorrelated');
    return (varY - varX + sqrt(pow(varY - varX, 2) + 4 * covXY * covXY)) /
        (2 * covXY);
  }

  return List.generate(dimCount, (i) => i == variableIndex ? 1.0 : coefficient(i));
}