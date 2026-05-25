import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../GlobalComponents/PreferenceManager.dart';

class ProfileProvider extends ChangeNotifier {
  String name = "";
  String phone = "";
  String Unit_Name = "";


  late double height;
  late double width;

  ProfileProvider() {
    final context = NavKey.navKey.currentState!.context;
    final size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
  }

  /// Load data (from API / SharedPreferences)
  Future<void> loadProfile() async {
    name = await PreferenceManager.instance.getStringValue('Operator_Name');
    phone = await PreferenceManager.instance.getStringValue("Mobile_No") ?? "No Phone";
    Unit_Name = await PreferenceManager.instance.getStringValue("Unit_Name") ?? "No Unit";
    log(name);
    log(phone);
    log(Unit_Name);
    notifyListeners();
  }

  /// Clear data on logout (optional)
  void clearProfile() {
    name = "";
    phone = "";
    Unit_Name = "";
    notifyListeners();
  }
}