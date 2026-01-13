import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'debug_app.dart';

void main() {
  runApp(
    ProviderScope(
      child: DebugApp(),
    ),
  );
}
