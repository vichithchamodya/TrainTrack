import 'package:shared_preferences/shared_preferences.dart';

class ThemePersistance {
  // store the saved theme
  Future<void> storeTheme(bool isDark) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isDark", isDark);
  }

  // load the saved theme
  Future<bool> loadTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("isDark") ?? false;
  }
}
