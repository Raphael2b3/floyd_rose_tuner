import 'package:auto_route/auto_route.dart';
import 'package:floyd_rose_tuner/provider/string_measure_state_provider.dart';
import 'package:floyd_rose_tuner/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class FloydRoseTunerLayoutPage extends ConsumerWidget {
  const FloydRoseTunerLayoutPage({super.key});

  static const double maxProgress = 18;

  double calculateProgress(int pageId, int stringIndex) {
    num v = pageId < 2 ? (pageId + stringIndex * 2) : (12 + stringIndex);
    return v / maxProgress;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int stringIndex = ref
        .watch(stringMeasureStateProvider)
        .currentStringIndex;
    return AutoRouter(
      builder: (context, content) {
        String? pageName = context.router.currentChild?.name;
        int pageIndex = switch (pageName) {
          FloydRoseTunerMeasureStringRoute.name => 0,
          FloydRoseTunerCheckStringRoute.name => 1,
          FloydRoseTunerRoute.name => 2,
          _ => -1,
        };
        var progress = calculateProgress(pageIndex, stringIndex);
        return Column(
          children: [
            if (pageIndex != -1) ...[
              LinearProgressIndicator(year2023: false, value: (progress)),
              Text(
                //"$pageName "
                "${(progress * 100).toInt()}%",
              ),
            ],
            Expanded(child: content),
          ],
        );
      },
    );
  }
}
