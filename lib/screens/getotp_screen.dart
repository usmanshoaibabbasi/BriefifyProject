import 'package:briefify/data/constants.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/text_fields_decorations.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:country_code_picker/country_code_picker.dart';
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
                  child: Container(
                    height: MediaQuery.of(context).size.height,
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
                          'Enter your phone number to get OTP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: screenSize.height / 30),
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
                                      ? Colors.grey.shade300
                                      : Colors.white,
                                  border: Border(
                                    top: BorderSide(
                                        color: _emailFocus.hasFocus ||
                                                _nameFocus.hasFocus ||
                                                _passwordFocus.hasFocus
                                            ? Colors.grey
                                            : Colors.white),
                                    bottom: BorderSide(
                                        color: _emailFocus.hasFocus ||
                                                _nameFocus.hasFocus ||
                                                _passwordFocus.hasFocus
                                            ? Colors.grey
                                            : Colors.white),
                                    left: BorderSide(
                                        color: _emailFocus.hasFocus ||
                                                _nameFocus.hasFocus ||
                                                _passwordFocus.hasFocus
                                            ? Colors.grey
                                            : Colors.white),
                                    right: BorderSide(
                                        color: _emailFocus.hasFocus ||
                                                _nameFocus.hasFocus ||
                                                _passwordFocus.hasFocus
                                            ? Colors.grey.shade300
                                            : Colors.grey),
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
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: kAuthInputDecoration.copyWith(
                                    prefixIcon: const Icon(
                                      Icons.phone,
                                      color: Colors.grey,
                                    ),
                                    hintText: 'Phone (optional)',
                                    fillColor: _emailFocus.hasFocus ||
                                            _nameFocus.hasFocus ||
                                            _passwordFocus.hasFocus
                                        ? Colors.grey.shade300
                                        : Colors.white,
                                  ),
                                  focusNode: _phoneFocus,
                                ),
                              ),
                            ],
                          ),
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
                                      print(selectedCountryCode);
                                      print(_phoneController.text);
                                      if (validnumber(context)) {
                                        Navigator.pushNamed(
                                          context,
                                          otpRoute,
                                          arguments: {
                                            'phoneNumber': selectedCountryCode +
                                                _phoneController.text,
                                          },
                                        );
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
          Positioned(
              bottom: 40,
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
                      color: kPrimaryColorLight,
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
