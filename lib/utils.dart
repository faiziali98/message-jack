import 'package:shared_preferences/shared_preferences.dart';


extension AppLaunch on SharedPreferences {
  static const _firstLaunchKey = 'firstLaunch';
  static Future<bool> isFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final firstLaunch = prefs.getBool(_firstLaunchKey) ?? true;
    if (firstLaunch) {
      await prefs.setBool(_firstLaunchKey, false);
    }
    return firstLaunch;
  }
}
