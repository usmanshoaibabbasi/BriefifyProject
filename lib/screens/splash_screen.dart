import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    gotoNextScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffbfbfb),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            gifLogo,
            height: 200,
          ),
          const SizedBox(width: double.infinity),
        ],
      ),
    );
  }

  void gotoNextScreen() async {
    String token = await Prefs().getApiToken();
    await Future.delayed(const Duration(seconds: 4));
    if (token.isEmpty) {
      Navigator.pushReplacementNamed(context, welcomeRoute);
    } else {
      try {
        Map results = await NetworkHelper().updateFirebaseToken();
        if (!results['error']) {
          UserModel _user = results['user'];
          print(_user.apiToken);
          print(_user.id.toString());
          final _userData = Provider.of<UserProvider>(context, listen: false);
          _userData.user = _user;
          Navigator.pushReplacementNamed(context, homeRoute);
        } else {
          SnackBarHelper.showSnackBarWithAction(context, () {
            gotoNextScreen();
          },
              message: results['errorData'],
              dismissDuration: const Duration(days: 1));
        }
      } catch (e) {
        SnackBarHelper.showSnackBarWithAction(context, () {
          gotoNextScreen();
        }, message: e.toString(), dismissDuration: const Duration(days: 1));
      }
    }
  }
}
