import 'package:briefify/data/constants.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/text_fields_decorations.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:briefify/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 31,
                      ),
                      Image.asset('assets/images/ic_launcher.png',
                          height: 100, width: 100, fit: BoxFit.cover),
                      const SizedBox(
                        height: 32,
                      ),
                      Text(
                        'Phone Verification',
                        style: TextStyle(
                          color: basiccolor,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenSize.height / 30),
                      Text(
                        'Enter the code we send you on your phone number',
                        style: TextStyle(
                          color: basiccolor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // TextField(
                      //   cursorColor: Colors.white,
                      //   keyboardType: TextInputType.emailAddress,
                      //   onChanged: (value) {
                      //     _otp = value;
                      //   },
                      //   textAlign: TextAlign.center,
                      //   decoration: kSearchInputDecoration.copyWith(
                      //     hintText: 'SMS Code',
                      //     hintStyle: TextStyle(color: Colors.grey.shade400),
                      //   ),
                      //   style: const TextStyle(color: kPrimaryTextColor),
                      // ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          onChanged: (value) {
                            _otp = value;
                          },
                          keyboardType: TextInputType.phone,
                          textAlignVertical: TextAlignVertical.bottom,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: inputField1(
                            label1: 'SMS Code',
                            context: context,
                            prefixicon: Icon(
                              CupertinoIcons.phone,
                              color: basiccolor,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_otp.length < 6) {
                                SnackBarHelper.showSnackBarWithoutAction(
                                    context,
                                    message: 'Invalid OTP');
                              } else {
                                // Todo Here to change
                                _signInWithPhoneNumber(_otp);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: basiccolor),
                            child: Text(
                              "Verify".toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            )),
                      ),
                      const SizedBox(height: 100.0),
                      _loading
                          ? const Center(
                              child: SpinKitDoubleBounce(
                                size: 40.0,
                                color: Colors.grey,
                              ),
                            )
                          : Container(),
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
          Positioned(
              bottom: 0,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, homeRoute, ModalRoute.withName(welcomeRoute));
                },
                child: Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: basiccolor,
                      borderRadius: BorderRadius.circular(200),
                    ),
                    child: Row(
                      children: const [
                        Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.white,
                        ),
                      ],
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
          updateUserphone();
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
        SnackBarHelper.showSnackBarWithoutAction(context,
            message: 'Phone Number Verified');
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
