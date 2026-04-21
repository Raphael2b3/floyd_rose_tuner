import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/floyd_rose_tuner_page.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_page.dart';
import 'package:floyd_rose_tuner/components/guitar_tuning_page.dart';
import 'package:floyd_rose_tuner/components/help_page.dart';
import 'package:floyd_rose_tuner/components/layout_page.dart';
import 'package:floyd_rose_tuner/components/standard_tuner_page.dart';
import 'package:floyd_rose_tuner/components/floyd_rose_tuner_setup_page.dart';
import 'package:floyd_rose_tuner/components/detuning_matrix_measure_page.dart';


part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      page: LayoutRoute.page,
      children: [
        AutoRoute(page: HelpRoute.page),
        AutoRoute(
          initial: true,
          page: FloydRoseTunerRoute.page,
          children: [
            AutoRoute(page: FloydRoseTunerSetupRoute.page, initial: true),
            AutoRoute(page: GuitarStateMeasureRoute.page),
            AutoRoute(page: GuitarTuningRoute.page),
            AutoRoute(page: DetuningMatrixMeasureRoute.page)
          ],
        ),
        AutoRoute(page: StandardTunerRoute.page),
      ],
    ),
  ];
}
