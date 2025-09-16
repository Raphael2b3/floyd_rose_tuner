import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/tuner_slider.dart';
import 'package:flutter/material.dart';

@RoutePage()
class StandardTunerPage extends StatelessWidget {
  const StandardTunerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [TunerSlider()],
          ),
        ),
      ),
    );
  }
}
