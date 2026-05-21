import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class Layout2Page extends StatelessWidget {
  const Layout2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AutoRouter(),
        ),
      ),
    );
  }
}
