import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

const NUMBER_OF_STRINGS = 6;

@JsonSerializable()
class GuitarState extends ListBase<num> {
  final List<num> _data = List<num>.filled(
    NUMBER_OF_STRINGS,
    0,
    growable: false,
  );

  GuitarState({Iterable<num>? values}) {
    if (values == null) {
      return;
    }
    if (values.length != NUMBER_OF_STRINGS) {
      throw ArgumentError('Must have exactly 6 elements');
    }
    int i = 0;
    for (num v in values) {
      _data[i++] = v;
    }
  }

  @override
  int get length => 6;

  @override
  set length(int newLength) {
    throw UnsupportedError('Cannot change length');
  }

  @override
  num operator [](int index) => _data[index];

  @override
  void operator []=(int index, num value) {
    _data[index] = value;
  }

  factory GuitarState.fromJson(List<dynamic> json) {
    if (json.length != NUMBER_OF_STRINGS) {
      throw ArgumentError('Must have exactly 6 elements');
    }

    return GuitarState(values: json.cast<num>());
  }

  List<num> toJson() => List<num>.from(_data);
}
