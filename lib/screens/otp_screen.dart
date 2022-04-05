import 'package:briefify/data/constants.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/text_fields_decorations.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool _loading = false;
  String _otp = '';
  String verificationID = '';
  String smsCode = '';
  String smsCodeError = '';

  @override
  void initState() {
    print(widget.phoneNumber);
    authenticateUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kSecondaryColorLight,
      body: SafeArea(
          child: Stack(
        children: [
          _loading
              ? const Center(
                  child: SpinKitDoubleBounce(
                    size: 50,
                    color: kPrimaryColorLight,
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenSize.height / 6),
                        const Text(
                          'Phone Verification',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenSize.height / 30),
                        const Text(
                          'Enter the code we send you on your phone number',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: screenSize.height / 30),
                        TextField(
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            _otp = value;
                          },
                          textAlign: TextAlign.center,
                          decoration: kSearchInputDecoration.copyWith(
                            hintText: 'SMS Code',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                          ),
                          style: const TextStyle(color: kPrimaryTextColor),
                        ),
                        SizedBox(height: screenSize.height / 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _loading
                                ? const Center(
                                    child: SpinKitDoubleBounce(
                                      size: 40.0,
                                      color: Colors.grey,
                                    ),
                                  )
                                : ButtonOne(
                                    title: 'Proceed',
                                    onPressed: () async {
                                      if (_otp.length < 6) {
                                        SnackBarHelper
                                            .showSnackBarWithoutAction(context,
                                                message: 'Invalid OTP');
                                      } else {
                                        _signInWithPhoneNumber(_otp);
                                      }
                                    }),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
          Positioned(
              child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
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
      )),
    );
  }

  void authenticateUser() async {
    FirebaseAuth _auth = await FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        timeout: Duration(seconds: 100),
        verificationCompleted: (AuthCredential authCredential) {
          print('verificationCompleted');
          print('OK' + authCredential.toString());
          setState(() {
            _loading = false;
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          print('verificationFailed');
          print('error // : ' + exception.message.toString());
          setState(() {
            _loading = false;
          });

          SnackBarHelper.showSnackBarWithoutAction(context,
              message: exception.message,
              dismissDuration: const Duration(seconds: 8));
          // Navigator.pop(context);
        },
        codeSent: (String verID, int? forceResend) {
          print('codeSent');
          print('sending code.....');
          verificationID = verID;
        },
        codeAutoRetrievalTimeout: (String verID) {
          print('codeAutoRetrievalTimeout');
          print(verID);
        });
  }

  void _signInWithPhoneNumber(String smsCode) async {
    setState(() {
      _loading = true;
    });

    FirebaseAuth auth = FirebaseAuth.instance;
    var _authCredential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: smsCode);
    auth
        .signInWithCredential(_authCredential)
        .then((UserCredential user) async {
      /// Auth successful
      try {
        if (user.user != null) {
          // updateUserphone();
        }
      } catch (e) {
        SnackBarHelper.showSnackBarWithoutAction(context,
            message: e.toString());
      }
    }).catchError((error) {
      setState(() {
        _loading = false;
      });

      /// Auth error
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: error.toString());

      print(error.toString());
    });
  }

  // TODO Here Is Function To Register User
  void updateUserphone() async {
    setState(() {
      _loading = true;
    });

    try {
      Map results = await NetworkHelper().updateUserphone(
        widget.phoneNumber,
      );
      if (!results['error']) {
        UserModel user = results['user'];
        final _userData = Provider.of<UserProvider>(context, listen: false);
        _userData.user = user;
        await Prefs().setApiToken(user.apiToken);
        await NetworkHelper().updateFirebaseToken();
        Navigator.pushNamedAndRemoveUntil(
            context, homeRoute, ModalRoute.withName(welcomeRoute));
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
