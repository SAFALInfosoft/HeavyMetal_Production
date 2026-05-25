import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../GlobalComponents/PreferenceManager.dart';
import '../../../GlobalComponents/api_service.dart';
import '../../Login_Screens/Login_Page.dart';

class DashboardProvider extends ChangeNotifier {
  late double height;
  late double width;

  DashboardProvider() {
    final context = NavKey.navKey.currentState!.context;
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
  }

  final List<Map<String, dynamic>> allMenuItems = [
    {
      "title": "Production",
      "icon": Icons.factory,
      "color": Colors.orange,
      "key": "Production"
    },
    {
      "title": "Transfer Memo",
      "icon": Icons.swap_horiz,
      "color": Colors.red,
      "key": "Transfer_memo"
    },
    {
      "title": "Maintenance",
      "icon": Icons.build,
      "color": Colors.blue,
      "key": "Maintenance"
    },
  ];

  bool isInitialized = false;

  void init(BuildContext context) {
    if (isInitialized) return;

    isInitialized = true;
    Check_Rights(context);
  }

  List<Map<String, dynamic>> menuItems = [];

  Future<void> Check_Rights(BuildContext context) async {
    try {
      final urnNo = await PreferenceManager.instance.getStringValue('Operator_URN_No');
      final token = await PreferenceManager.instance.getStringValue('Access_Token');
      final coCode = await PreferenceManager.instance.getStringValue('CO_CODE');
      final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL');

      final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);

      final response = await apiService.get(
        'Login/Check_Rights',
        queryParameters: {
          'O_URN_No': urnNo.toString(),
          'Access_Token': Uri.encodeComponent(token).toString(),
          'CO_CODE': coCode.toString(),
          'UR_CODE': "1",
        },
      );



      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);
      log(data);

      /// 🔴 Token invalid check
      if (data['message'] == "User Id or Token is Invalid.") {
        await PreferenceManager.instance.setBooleanValue("Login", false);
        isInitialized = false;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
        return;
      }

      /// ✅ Extract rights
      final rights = data['message'][0];
      var Operator_Name=rights['Operator_Name'] ?? 'User';
      await PreferenceManager.instance.setStringValue('Operator_Name', Operator_Name);
      var Unit_Name=rights['Unit_Name'] ;
      await PreferenceManager.instance.setStringValue('Unit_Name', Unit_Name);
      var Mobile_No=rights['Mobile_No'] ;
      await PreferenceManager.instance.setStringValue('Mobile_No', Mobile_No);
      var Operator_Role=rights['Operator_Role'] ;
      await PreferenceManager.instance.setStringValue('Operator_Role', Operator_Role);


      menuItems = allMenuItems.where((item) {
        return rights[item['key']] == true;
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error: $e');
    }
  }
}
