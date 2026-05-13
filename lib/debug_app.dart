import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main2() {
  runApp(DebugApp());
}

class DebugApp extends StatefulWidget {
  const DebugApp({super.key});

  @override
  State<DebugApp> createState() => _DebugAppState();
}

class _DebugAppState extends State<DebugApp> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        home: Material(
          child: Column(
            children: [
              Text(
                "Yarak ",
                style: TextStyle(color: Colors.black),
              ),
              TextField()
            ],
          ),
        ),
      ),
    );
  }
}
