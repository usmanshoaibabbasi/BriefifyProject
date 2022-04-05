import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/text_fields_decorations.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _loading = false;

  @override
  void initState() {
    setFocusListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColorDark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80, right: 30, left: 30),
                  child: Image.asset(
                    appLogo,
                    width: 200,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Text(
                    'Login to briefify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      // left: !_emailFocus.hasFocus && !_passwordFocus.hasFocus
                      //     ? 40
                      //     : _emailFocus.hasFocus
                      //         ? 40
                      //         : 80,
                      left: 40,
                      right: 40),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: kAuthInputDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      hintText: 'Email',
                      fillColor: _passwordFocus.hasFocus ? Colors.grey.shade300 : Colors.white,
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _emailFocus,
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(
                      // left: !_emailFocus.hasFocus && !_passwordFocus.hasFocus
                      //     ? 40
                      //     : _passwordFocus.hasFocus
                      //         ? 40
                      //         : 80,
                      left: 40,
                      right: 40),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: kAuthInputDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.password,
                        color: Colors.grey,
                      ),
                      hintText: 'Password',
                      fillColor: _emailFocus.hasFocus ? Colors.grey.shade300 : Colors.white,
                    ),
                    focusNode: _passwordFocus,
                  ),
                ),
                const SizedBox(height: 30),
                _loading
                    ? const Center(child: SpinKitCircle(size: 50, color: kPrimaryColorLight))
                    : ButtonOne(
                        title: 'Login',
                        onPressed: () {
                          if (validData()) {
                            loginUser();
                          }
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextButton(
                      onPressed: () {
                        if (!_loading) {
                          Navigator.pushNamed(context, forgotPasswordRoute);
                        }
                      },
                      child: const Text(
                        'Forget Password ?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )),

                // TextButton(
                //   onPressed: () {
                //     if (!_loading) {
                //       Navigator.pushNamed(context, registerRoute);
                //     }
                //   },
                //   child: const Text(
                //     'Create Account',
                //     style: TextStyle(
                //       color: Colors.white,
                //       decoration: TextDecoration.underline,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Positioned(
              child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: kPrimaryColorLight,
                  borderRadius: BorderRadius.circular(200),
                ),
                child: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                )),
          )),
        ],
      ),
    );
  }

  void setFocusListeners() {
    _emailFocus.requestFocus();
    _emailFocus.addListener(() {
      setState(() {});
    });
    _passwordFocus.addListener(() {
      setState(() {});
    });
  }

  bool validData() {
    if (!isEmail(_emailController.text)) {
      SnackBarHelper.showSnackBarWithoutAction(context, message: 'Please enter a valid email');
      return false;
    }
    if (_passwordController.text.length < 6) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Password should be at least 6 character long');
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      _loading = true;
    });

    try {
      Map results = await NetworkHelper().loginUser(
        _emailController.text,
        _passwordController.text,
      );
      if (!results['error']) {
        UserModel user = results['user'];
        final _userData = Provider.of<UserProvider>(context, listen: false);
        _userData.user = user;
        await Prefs().setApiToken(user.apiToken);
        await NetworkHelper().updateFirebaseToken();
        Navigator.pushNamedAndRemoveUntil(context, homeRoute, ModalRoute.withName(welcomeRoute));
      } else {
        SnackBarHelper.showSnackBarWithoutAction(context, message: results['errorData']);
      }
    } catch (e) {
      SnackBarHelper.showSnackBarWithoutAction(context, message: e.toString());
    }
    setState(() {
      _loading = false;
    });
  }
}
