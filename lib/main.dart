import 'package:floyd_rose_tuner/utils/async_error_logger.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'floyd_rose_tuner.dart';

void main() {
  runApp(
    ProviderScope(observers: [AsyncErrorLogger()], child: FloydRoseTuner()),
  );
}
