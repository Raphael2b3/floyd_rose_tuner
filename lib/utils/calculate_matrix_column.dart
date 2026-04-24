import 'dart:math';

import 'package:floyd_rose_tuner/types/guitar_state.dart';

List<double> calculateMatrixColumn(
  // TODO make this more elegant
  List<GuitarState> samples,
  int variableIndex,
) {
  var variables = [];
  Map<int, List<num>> ys = {};
  int N = samples.length;
  for (var sample in samples) {
    assert(sample.length > variableIndex);
    variables.add(sample[variableIndex]);

    for (int i = 0; i < sample.length; i++) {
      if (i == variableIndex) {
        continue;
      }
      if (!ys.containsKey(i)) {
        ys[i] = [];
      }
      ys[i]!.add(sample[i]);
    }
  }

  var meanOfVariables =
      variables.reduce((value, element) {
        return value + element;
      }) /
      variables.length;

  var meanOfYs = ys.map((key, value) {
    return MapEntry(
      key,
      value.reduce((value, element) => value + element) / value.length,
    );
  });

  num variableSampleVariance = 0;
  Map<int, num> ysSampleVariances = {};
  Map<int, num> sampleCovariances = {};

  for (int i = 0; i < N; i++) {
    assert(variables[i] != 0);
    variableSampleVariance +=
        (variables[i] - meanOfVariables) * (variables[i] - meanOfVariables);
    for (int key in ys.keys) {
      var y = ys[key];
      if (!ysSampleVariances.containsKey(key)) {
        ysSampleVariances[key] = 0;
      }
      ysSampleVariances[key] =
          ysSampleVariances[key]! +
          (y![i] - meanOfYs[key]!) * (y[i] - meanOfYs[key]!);
      if (!sampleCovariances.containsKey(key)) {
        sampleCovariances[key] = 0;
      }
      sampleCovariances[key] =
          sampleCovariances[key]! +
          (variables[i] - meanOfVariables) * (y[i] - meanOfYs[key]!);
    }
  }

  for (int key in ys.keys) {
    ysSampleVariances[key] = ysSampleVariances[key]! / (N - 1);
    sampleCovariances[key] = sampleCovariances[key]! / (N - 1);
  }
  variableSampleVariance /= (N - 1);
  var coefficients = <double>[];
  for (int i = 0; i < samples[0].length; i++) {
    if (i == variableIndex) {
      coefficients.add(1);
      continue;
    }
    var coefficient =
        (ysSampleVariances[i]! -
            variableSampleVariance +
            sqrt(
              pow(ysSampleVariances[i]! - variableSampleVariance, 2) +
                  4 * sampleCovariances[i]! * sampleCovariances[i]!,
            )) /
        (2 * sampleCovariances[i]!);
    coefficients.add(coefficient);
  }

  return coefficients;
}
