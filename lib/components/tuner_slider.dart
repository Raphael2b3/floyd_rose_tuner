import 'package:floyd_rose_tuner/utils/random_stream.dart';
import 'package:flutter/material.dart';

class TunerSlider extends StatefulWidget {
  TunerSlider({super.key, this.goal=0.5});
  double goal;
  @override
  State<TunerSlider> createState() => _TunerSliderState();
}

class _TunerSliderState extends State<TunerSlider> {
  var v = 0.3;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: inputStream(),
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (!snapshot.hasData) return const Text("No Data");
        return Column(
        children: [
          Text((snapshot.data!.toString())),
          Slider(
              label: "1",
              year2023: false,
              value: snapshot.data!,
              onChanged: (d) {
                print(d);
              },
          ),

        ],
      );}
    );
  }
}
