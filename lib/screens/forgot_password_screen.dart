import 'package:briefify/data/constants.dart';
import 'package:briefify/data/text_fields_decorations.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:validators/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColorDark,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: kAuthInputDecoration.copyWith(
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    hintText: 'Email',
                    fillColor: Colors.white,
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 20),
              _loading
                  ? const Center(
                      child: SpinKitCircle(size: 50, color: kPrimaryColorLight))
                  : ButtonOne(
                      title: 'Reset',
                      onPressed: () {
                        if (isEmail(_emailController.text)) {
                          resetPassword();
                        }
                      },
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                    ),
            ],
          ),
          Positioned(
              child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: kPrimaryColorLight,
                  borderRadius: BorderRadius.circular(200),
                ),
                child: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                )),
          ))
        ],
      ),
    );
  }

  void resetPassword() async {
    setState(() {
      _loading = true;
    });

    try {
      Map results = await NetworkHelper().resetPassword(_emailController.text);
      if (!results['error']) {
        SnackBarHelper.showSnackBarWithoutAction(context,
            message: results['message']);
        _emailController.text = '';
      } else {
        SnackBarHelper.showSnackBarWithoutAction(context,
            message: results['errorData']);
      }
    } catch (e) {
      SnackBarHelper.showSnackBarWithoutAction(context, message: e.toString());
    }
    setState(() {
      _loading = false;
    });
  }
}
