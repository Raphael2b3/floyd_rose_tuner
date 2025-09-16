import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/pages/floyd_rose_tuner_page.dart';
import 'package:floyd_rose_tuner/pages/help_page.dart';
import 'package:floyd_rose_tuner/pages/layout_page.dart';
import 'package:floyd_rose_tuner/pages/standard_tuner_page.dart';
part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      page: LayoutRoute.page,
      children: [
        AutoRoute(page: HelpRoute.page, initial: true),
        AutoRoute(page: FloydRoseTunerRoute.page),
        AutoRoute(page: StandardTunerRoute.page)
      ],
    ),
  ];
}
