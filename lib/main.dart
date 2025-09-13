import 'package:floyd_rose_tuner/pages/configure_page.dart';
import 'package:floyd_rose_tuner/pages/help_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floyd Rose Tuner',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.help),
            icon: Icon(Icons.home_outlined),
            label: 'Help',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.tune)),
            label: 'Configure',
          ),
          NavigationDestination(
            icon: Icon(Icons.star),
            label: 'Floyd Rose',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border),
            label: 'Standard Tuner',
          ),
        ],
      ),
      body: [
        const HelpPage(),
        const ConfigurePage(),
        const HelpPage(),
        const HelpPage(),
      ][currentPageIndex],
    );
  }
}
