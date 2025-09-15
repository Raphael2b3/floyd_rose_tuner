import 'package:floyd_rose_tuner/pages/layout.dart';
import 'package:flutter/material.dart';

class FloydRoseTuner extends StatelessWidget {
  const FloydRoseTuner({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floyd Rose Tuner',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        sliderTheme: SliderThemeData(year2023:false)
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const Layout(),
    );
  }
}
