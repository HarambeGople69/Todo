import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentTheme extends ChangeNotifier {
  String key = "theme";
  bool darkTheme = true;

  CurrentTheme() {
    loadFromPrefs();
  }
  loadFromPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    darkTheme = pref.getBool(key) ?? true;
    notifyListeners();
  }

  toggleTheme() {
    darkTheme = !darkTheme;
    saveToPrefs();
    notifyListeners();
  }

  saveToPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(key, darkTheme);
  }

  // Brightness currentTheme = Brightness.dark;
  // Future<Brightness> changeTheme() async {
  //   bool isLight = await CheckBool().getLightValue();
  //   if (isLight == false) {
  //     currentTheme = Brightness.dark;
  //     print("false");
  //     notifyListeners();
  //     return currentTheme;
  //   } else {
  //     currentTheme = Brightness.light;
  //     print("true");
  //     notifyListeners();
  //     return currentTheme;
  //   }
  // }
}
