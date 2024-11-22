import 'dart:io';

import 'package:floyd_rose_tuner/components/tuner_slider.dart';
import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher_string.dart';

class ConfigurePage extends StatelessWidget {
  const ConfigurePage({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return const SizedBox.expand(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "We configure the tuner for your Floyd Rose Guitar",
              textAlign: TextAlign.center,
            ),
            TunerSlider()
          ],
        ),
      ),
    );
  }
}
