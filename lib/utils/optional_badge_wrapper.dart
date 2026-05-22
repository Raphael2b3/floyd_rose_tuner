import 'package:flutter/material.dart';

Widget OptionalBadgeWrapper({required Widget child, required bool showBadge}) =>
    showBadge ? Badge(child: child) : child;
