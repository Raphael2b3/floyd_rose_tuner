import 'package:flutter/material.dart';

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
    return MaterialApp(
      home: Material(
        child: DefaultTabController(
          length: 2,
          initialIndex: index,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                tabs: List.generate(
                  2,
                  (i) => SizedBox(
                    height: 100,
                    width: 100,
                    child: Tab(child: Text("$i")),
                  ),
                ),
                onTap: (i) => setState(() => index = i),
              ),
              OutlinedButton(
                onPressed: () => setState(() => index = (index + 1) % 2),
                child: Text("Current Index $index"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
