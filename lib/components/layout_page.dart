import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
        routes: const [HelpRoute(), FloydRoseTunerRoute(), StandardTunerRoute()],
        bottomNavigationBuilder: (_, tabsRouter) {
          return BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Help',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'Floyd Rose',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star_border),
                label: 'Standard Tuner',
              ),
            ],

          );
        });
  }
}
