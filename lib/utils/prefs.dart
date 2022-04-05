import 'package:briefify/data/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  Future<String> getApiToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // String apiToken =
    // 's2Nd55QWSnb4mNXA7So6wdCBBMB82PlFVflHuRDXEKtsCXEo3YLdC6B00Usw2';

    String apiToken = prefs.getString(API_TOKEN) ?? '';
    return apiToken;
  }

  Future<bool> setApiToken(String apiToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(API_TOKEN, apiToken);
    return true;
  }

  Future<bool> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(API_TOKEN, '');
    return true;
  }
}
