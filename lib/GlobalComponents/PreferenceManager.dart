import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager{
  // static SharedPreferences _sharedPreferences;
  static const _keyUserName= "userName";

  String keyLoginSession="KeyLoginSession";

  PreferenceManager._privateConstructor();

  static final PreferenceManager instance =
  PreferenceManager._privateConstructor();

  Future<void>  setStringValue(String key, String value) async {
    final SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString(key, value);
  }

  Future<String> getStringValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString(key) ?? "";
  }

  setUserLoginSession() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool(keyLoginSession, true);
  }

  Future<bool> getLoginSession() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool(keyLoginSession) ?? false;
  }

  Future<bool> containsKey(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.containsKey(key);
  }


  setIntegerValue(String key, int value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setInt(key, value);
  }

  Future<int> getIntegerValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getInt(key) ?? 0;
  }

  setBooleanValue(String key, bool value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool(key, value);
  }

  Future<bool> getBooleanValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool(key) ?? false;
  }

  removeValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.remove(key);
  }

  removeAll() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.clear();
  }
}

class NavKey {
  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
}