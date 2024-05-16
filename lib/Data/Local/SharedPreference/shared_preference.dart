import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<void> saveData(name, email, url, phone) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("NAME", name);
    pref.setString("EMAIL", email);
    pref.setString("URL", url);
    pref.setString("PHONE", phone);
  }

  static Future<String> getEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("EMAIL")!;
  }

  static Future<String> getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("NAME")!;
  }

  static Future<String> getNumber() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("EMAIL")!;
  }

  static Future<String> getUrl() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("URL")!;
  }
}
