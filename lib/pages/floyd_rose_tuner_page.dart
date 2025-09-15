
import 'package:floyd_rose_tuner/components/config_selector.dart';
import 'package:floyd_rose_tuner/components/tuner_slider.dart';
import 'package:floyd_rose_tuner/floyd_rose_tuner.dart';
import 'package:floyd_rose_tuner/floyd_rose_tuner.dart';
import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher_string.dart';

class FloydRoseTunerPage extends StatelessWidget {
  const FloydRoseTunerPage({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return SizedBox.expand(
      child :Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ConfigSelector(),
        )
      ),
    );
  }
}
