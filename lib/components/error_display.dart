import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final String text;

  const ErrorDisplay(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(text), CircularProgressIndicator()],
      ),
    );
  }
}
