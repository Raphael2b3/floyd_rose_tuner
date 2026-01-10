import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'volume_threshold_provider.g.dart';
@riverpod
class VolumeThreshold extends _$VolumeThreshold {
  @override
  double build() => -17;

  void set(double value) => state = value;
}

