import 'package:flutter/material.dart';

class DisplayError extends StatelessWidget {
  final String text;

  const DisplayError(this.text, {super.key});

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
