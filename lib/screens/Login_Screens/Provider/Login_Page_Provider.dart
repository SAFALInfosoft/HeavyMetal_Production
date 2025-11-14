import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../GlobalComponents/PreferenceManager.dart';
import '../../../GlobalComponents/api_service.dart';
import '../Model/Login_Page_Model.dart';

class LoginPageProvider extends ChangeNotifier{
  late double height;
  late double width;

  TextEditingController mobileNoController = TextEditingController();
  TextEditingController MPinController = TextEditingController();




  /// Call this from a widget to capture screen size safely
  void setScreenSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    notifyListeners();
  }

  /// Login API
  Future<bool> login(String mobileNo, String mpin) async {
    final baseUrl = await PreferenceManager.instance.getStringValue('Base_URL'); // ✅ await here
    final NewApiService apiService = NewApiService(defaultBaseUrl: baseUrl);
    final payload = {'Mobile_No': mobileNo, 'MPIN': mpin};

    try {
      final response = await apiService.post('Login/LogIn_Check', data: payload);

      final Map<String, dynamic> data =
      response is String ? jsonDecode(response) : Map<String, dynamic>.from(response);

      final loginResponse = LoginResponse.fromJson(data);

      if (loginResponse.settings.success == '1' &&
          loginResponse.message.isNotEmpty) {
        final msg = loginResponse.message.first;

        // Save data
        await PreferenceManager.instance.setStringValue('Operator_URN_No', msg.operatorUrnNo);
        await PreferenceManager.instance.setStringValue('Access_Token', msg.accessToken);
        await PreferenceManager.instance.setStringValue('CO_CODE', msg.coCode);
        await PreferenceManager.instance.setBooleanValue("Login", true);

        return true; // ✅ indicate success
      }
      return false; // failed
    } catch (e) {
      debugPrint('❌ Login Error: $e');
      return false;
    }
  }


  LoginPageProvider (){
    final context = NavKey.navKey.currentState!.context;
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
  }
}