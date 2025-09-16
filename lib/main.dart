import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'components/floyd_rose_tuner.dart';

void main() {
  runApp(
    ProviderScope(
      child: FloydRoseTuner(),
    ),
  );
}
