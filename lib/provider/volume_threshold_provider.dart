import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'volume_threshold_provider.g.dart';

@Riverpod(keepAlive: true)
class VolumeThreshold extends _$VolumeThreshold {
  @override
  double build() => -43;

  void set(double value) => state = value;
}

