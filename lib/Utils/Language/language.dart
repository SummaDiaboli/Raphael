import 'package:shared_preferences/shared_preferences.dart';

Future<String> getCurrentLanguage() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String language = (preferences.getString('language') ?? 'en');

  return language;
}

Future<void> setNewLanguage(String newLanguage) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String oldLanguage = preferences.getString('language');

  if (oldLanguage != newLanguage) {
    preferences.setString('language', newLanguage);
    print("User langauge is ${preferences.getString('language')}");
  } else {
    print("There's no need to change the langauge");
  }
}

Future<void> resetUserLanguage() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('language', 'en');
}
