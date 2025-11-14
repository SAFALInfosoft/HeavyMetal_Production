import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../GlobalComponents/PreferenceManager.dart';
import '../../../../GlobalComponents/api_service.dart';
import '../../../Production/Production_Form/Model/URN_No_Model.dart';


class Maintanance_Menu_Provider extends ChangeNotifier {
  late double height;
  late double width;



  String? generatedUrn;

  Maintanance_Menu_Provider() {
    final context = NavKey.navKey.currentState!.context;
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
  }

  final menuItems = [
    {
      "title": "Preventing",
      "icon": Icons.shield_outlined,
      "color": Colors.orange,
    },
    {
      "title": "Breakdown",
      "icon": Icons.construction,
      "color": Colors.red,
    },
    {
      "title": "Recovery",
      "icon": Icons.build_outlined,
      "color": Colors.blue,
    },
  ];


}
