import 'package:floyd_rose_tuner/router.dart';
import 'package:flutter/material.dart';

class FloydRoseTuner extends StatelessWidget {
  FloydRoseTuner({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Floyd Rose Tuner',
      theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          sliderTheme: SliderThemeData(year2023: false)),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      routerConfig: _appRouter.config(),
    );
  }
}
