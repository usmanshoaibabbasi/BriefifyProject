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
import 'package:briefify/widgets/textfield.dart';
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
  bool hidePassword = true;
  @override
  void initState() {
    setFocusListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 31,),
                  Image.asset('assets/images/ic_launcher.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover),
                  const SizedBox(height: 32,),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: basiccolor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 15,),
                  Text(
                    'Login Now',
                    style: TextStyle(
                      color: basiccolor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 41,),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textAlignVertical: TextAlignVertical.bottom,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      decoration: inputField1(
                        label1: 'Email',
                        context: context,
                        prefixicon: Icon(
                          CupertinoIcons.mail,
                          color: basiccolor,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.emailAddress,
                      textAlignVertical: TextAlignVertical.bottom,
                      textInputAction: TextInputAction.next,
                      obscureText: hidePassword,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      decoration: inputField1(
                          label1: 'Password',
                          context: context,
                          prefixicon: Icon(
                            CupertinoIcons.padlock,
                            color: basiccolor,
                            size: 22,
                          ),
                          suffixIcon: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black26,
                            ),
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _loading
                      ? const Center(child: SpinKitCircle(size: 50, color: kPrimaryColorLight))
                      : Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: basiccolor),
                                onPressed: () {
                                  if (validData()) {
                                    loginUser();
                                  }
                                },
                        child: Text(
                          "Login".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                        )),
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
                            fontSize: 16,
                            color: Colors.blue,
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
                top: 31,
                left: 15,
                child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: basiccolor,
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: const Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.white,
                  )),
            )),
          ],
        ),
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
