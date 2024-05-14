import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPrefs instance = SharedPrefs();
  final String _login_time_key = "login_time";
  final String _logout_time_key = "logout_time";
  final String _login_place_key = "login-place";

  // SharedPrefs() {}

  Future<void> saveLoginTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_login_time_key, time.toString());
  }

  Future<String?> getLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_login_time_key);
  }

  Future<void> saveLogoutTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_logout_time_key, time.toString());
  }

  Future<String?> getLogoutTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_logout_time_key);
  }

  Future<void> saveLoginPlace(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _login_place_key, "${position.latitude}:${position.longitude}");
  }

  Future<Map<String, double>?> getLoginPlace() async {
    final prefs = await SharedPreferences.getInstance();
    final res = prefs.getString(_login_place_key);
    print(res);
    if (res != null) {
      Map<String, double> pos = {
        "latitude": double.parse(res.split(":")[0]),
        "longitude": double.parse(res.split(":")[1]),
      };
      return pos;
    }
    return null;
  }
}
