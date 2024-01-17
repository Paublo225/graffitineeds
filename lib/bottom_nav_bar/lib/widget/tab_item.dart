import 'package:flutter/material.dart';

class TabItem {
  String label;
  Widget page;
  Widget? icon;
  String? initialRoute;
  Route<dynamic>? Function(RouteSettings)? settings;

  TabItem(
      {required this.label,
      required this.page,
      this.icon,
      this.initialRoute,
      this.settings});
}
