import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/components/calibration_change_string_page.dart';
import 'package:floyd_rose_tuner/components/calibration_check_string_page.dart';
import 'package:floyd_rose_tuner/components/calibration_control_page.dart';
import 'package:floyd_rose_tuner/components/calibration_layout_page.dart';
import 'package:floyd_rose_tuner/components/calibration_measure_string_page.dart';
import 'package:floyd_rose_tuner/components/floyd_rose_tuner_layout_page.dart';
import 'package:floyd_rose_tuner/components/floyd_rose_tuner_setup_page.dart';
import 'package:floyd_rose_tuner/components/floyd_rose_tuning_page.dart';
import 'package:floyd_rose_tuner/components/guitar_page.dart';
import 'package:floyd_rose_tuner/components/guitar_state_measure_page.dart';
import 'package:floyd_rose_tuner/components/guitar_tuning_setup_page.dart';
import 'package:floyd_rose_tuner/components/help_page.dart';
import 'package:floyd_rose_tuner/components/root_layout_page.dart';
import 'package:floyd_rose_tuner/components/standard_tuner_page.dart';
import "package:flutter/widgets.dart";
part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      page: RootLayoutRoute.page,
      children: [
        AutoRoute(page: HelpRoute.page),
        AutoRoute(
          initial: true,
          page: FloydRoseTunerLayoutRoute.page,
          children: [
            AutoRoute(page: FloydRoseTunerSetupRoute.page, initial: true),
            AutoRoute(page: FloydRoseTuningRoute.page),
            AutoRoute(
              page: CalibrationLayoutRoute.page,
              children: [
                AutoRoute(
                  page: CalibrationMeasureStringRoute.page,
                  initial: true,
                ),
                AutoRoute(page: CalibrationChangeStringRoute.page),
                AutoRoute(page: CalibrationCheckStringRoute.page),
              ],
            ),
            AutoRoute(page: GuitarRoute.page),
            AutoRoute(page: CalibrationControlRoute.page),
            AutoRoute(page: GuitarTuningSetupRoute.page),
          ],
        ),
        AutoRoute(page: StandardTunerRoute.page),
      ],
    ),
  ];
}
