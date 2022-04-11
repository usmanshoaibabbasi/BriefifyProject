import 'package:briefify/data/constants.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/text_fields_decorations.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:briefify/widgets/textfield.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GETOTPSCREEN extends StatelessWidget {
  GETOTPSCREEN({Key? key}) : super(key: key);

  bool _loading = false;
  String _otp = '';
  String verificationID = '';
  String smsCode = '';
  String smsCodeError = '';

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  String selectedCountryCode = '+1';
  final TextEditingController _phoneController = TextEditingController();

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
                  child: Container(
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
                          'Phone Verification',
                          style: TextStyle(
                            color: basiccolor,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15,),
                         Text(
                          'Enter your phone number to get OTP',
                          style: TextStyle(
                            color: basiccolor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const SizedBox(height: 41,),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: Row(
                            children: [
                              Container(
                                height: 59,
                                decoration: BoxDecoration(
                                  color: _emailFocus.hasFocus ||
                                          _nameFocus.hasFocus ||
                                          _passwordFocus.hasFocus
                                      ? basiccolor
                                      : Colors.white,
                                  border: Border(
                                    top: BorderSide(
                                        color: _emailFocus.hasFocus ||
                                                _nameFocus.hasFocus ||
                                                _passwordFocus.hasFocus
                                            ? basiccolor
                                            : basiccolor),
                                    bottom: BorderSide(
                                        color: _emailFocus.hasFocus ||
                                                _nameFocus.hasFocus ||
                                                _passwordFocus.hasFocus
                                            ? basiccolor
                                            : basiccolor),
                                    left: BorderSide(
                                        color: _emailFocus.hasFocus ||
                                                _nameFocus.hasFocus ||
                                                _passwordFocus.hasFocus
                                            ? basiccolor
                                            : basiccolor),
                                    right: BorderSide(
                                        color: _emailFocus.hasFocus ||
                                                _nameFocus.hasFocus ||
                                                _passwordFocus.hasFocus
                                            ? basiccolor
                                            : basiccolor),
                                  ),
                                ),
                                child: CountryCodePicker(
                                  showFlagMain: false,
                                  initialSelection: 'US',
                                  onChanged: (CountryCode code) {
                                    if (code.dialCode != null) {
                                      selectedCountryCode = code.dialCode!;
                                    }
                                  },
                                ),
                              ),
                              Flexible(
                                child:
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    textAlignVertical: TextAlignVertical.bottom,
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: inputField1(
                                      label1: 'Phone (optional)',
                                      context: context,
                                      prefixicon: Icon(
                                        CupertinoIcons.phone,
                                        color: basiccolor,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                                // TextField(
                                //   controller: _phoneController,
                                //   keyboardType: TextInputType.phone,
                                //   decoration: kAuthInputDecoration.copyWith(
                                //     prefixIcon: const Icon(
                                //       Icons.phone,
                                //       color: Colors.grey,
                                //     ),
                                //     hintText: 'Phone (optional)',
                                //     fillColor: _emailFocus.hasFocus ||
                                //             _nameFocus.hasFocus ||
                                //             _passwordFocus.hasFocus
                                //         ? Colors.grey.shade300
                                //         : Colors.white,
                                //   ),
                                //   focusNode: _phoneFocus,
                                // ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                         margin: const EdgeInsets.symmetric(horizontal: 15),
                         width: MediaQuery.of(context).size.width,
                         height: 50,
                               child: ElevatedButton(
                                   onPressed: () async {
                                     print(selectedCountryCode);
                                     print(_phoneController.text);
                                     if (validnumber(context)) {
                                       Navigator.pushNamed(
                                         context,
                                         otpRoute,
                                         arguments: {
                                           'phoneNumber':
                                               selectedCountryCode +
                                                   _phoneController.text,
                                         },
                                       );
                                     }
                                   },
                                   style: ElevatedButton.styleFrom(
                                       primary: basiccolor),
                                   child: Text(
                                     "Proceed".toUpperCase(),
                                     style: const TextStyle(
                                         color: Colors.white,
                                         fontWeight: FontWeight.bold,
                                         fontSize: 18),
                                   )),
                             ),
                        _loading
                            ? const Center(
                          child: SpinKitDoubleBounce(
                            size: 40.0,
                            color: Colors.grey,
                          ),
                        )
                            :
                            Container(),
                        const SizedBox(height: 100.0),
                      ],
                    ),
                  ),
                ),
          Positioned(
            top: 31,
              left: 15,
              child: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, welcomeRoute);
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

  bool validnumber(context) {
    if (_phoneController.text.trim().length < 5) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Please enter valid Number');
      return false;
    }
    return true;
  }
}
