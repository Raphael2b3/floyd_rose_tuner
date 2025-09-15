
import 'package:floyd_rose_tuner/components/tuner_slider.dart';
import 'package:flutter/material.dart';

import 'floyd_rose_tuner_page.dart';
import 'help_page.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
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
        const FloydRoseTunerPage(),
        TunerSlider(),
      ][currentPageIndex],
    );
  }
}
