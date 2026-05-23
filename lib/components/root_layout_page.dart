import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RootLayoutPage extends StatelessWidget {
  const RootLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      resizeToAvoidBottomInset: true,
      homeIndex: 1,
      transitionBuilder: (context, child, animation) {
        return SizedBox.expand(
          child: Center(
            child: Padding(padding: const EdgeInsets.all(16.0), child: child),
          ),
        );
      },
      routes: const [
        HelpRoute(),
        FloydRoseTunerLayoutRoute(),
        StandardTunerRoute(),
      ],
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
      },
    );
  }
}
