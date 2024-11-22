import 'package:flutter/material.dart';

class TunerSlider extends StatefulWidget {
  const TunerSlider({super.key});

  @override
  State<TunerSlider> createState() => _TunerSliderState();
}

class _TunerSliderState extends State<TunerSlider> {
  var v = 0.3;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("S$v"),
        Slider(
            year2023: false,
            value: v, onChanged: (d) {
          setState(() {
            v = d;
          });
        }),
      ],
    );
  }
}
