import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../GlobalComponents/PreferenceManager.dart';

class DashboardProvider extends ChangeNotifier {
  late double height;
  late double width;

  DashboardProvider() {
    final context = NavKey.navKey.currentState!.context;
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
  }

  final menuItems = [
    {
      "title": "Production",
      "icon": Icons.factory,
      "color": Colors.orange,
    },
    {
      "title": "Transfer Memo",
      "icon": Icons.swap_horiz,
      "color": Colors.red,
    },
    {
      "title": "Maintenance",
      "icon": Icons.build,
      "color": Colors.blue,
    },
  ];
}
