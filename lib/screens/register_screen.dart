import 'package:briefify/data/constants.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  DateTime? date;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  DateTime _selectedDate = DateTime.parse('2013-01-01');
  bool hidePassword = true;

  final List<String> credibility = ['Teacher', 'School', 'Business'];
  String _selectedCredibility = 'Teacher';
  String selectedCountryCode = '+1';
  bool _loading = false;
  String staticphoneNumber = '0000000000';

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  var device_id;

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
                  const SizedBox(
                    height: 31,
                  ),
                  Image.asset('assets/images/ic_launcher.png',
                      height: 100, width: 100, fit: BoxFit.cover),
                  const SizedBox(
                    height: 32,
                  ),
                  const Text(
                    'Create your account',
                    style: TextStyle(
                      color: basiccolor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 41,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      textAlignVertical: TextAlignVertical.bottom,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      decoration: inputField1(
                        label1: 'User Name',
                        context: context,
                        prefixicon: const Icon(
                          CupertinoIcons.person,
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
                        prefixicon: const Icon(
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
                          prefixicon: const Icon(
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
                          )),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _selectDate();
                    },
                    child: AbsorbPointer(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          controller: _dobController,
                          readOnly: true,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: inputField1(
                            label1: '',
                            context: context,
                            prefixicon: const Icon(
                              CupertinoIcons.calendar,
                              color: basiccolor,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      color: _emailFocus.hasFocus ||
                              _nameFocus.hasFocus ||
                              _passwordFocus.hasFocus ||
                              _phoneFocus.hasFocus
                          ? Colors.grey.shade300
                          : Colors.white,
                    ),
                    child: DropdownButton<String>(
                      items: getDropDownCredibility(),
                      value: _selectedCredibility,
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (String? v) {
                        setState(() {
                          _selectedCredibility = v ?? credibility[0];
                        });
                      },
                      icon: const Icon(Icons.keyboard_arrow_down_sharp),
                      iconSize: 30,
                      iconEnabledColor: kPrimaryColorLight,
                      dropdownColor: Colors.white,
                      itemHeight: 50,
                      style: const TextStyle(
                        color: kSecondaryColorDark,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: basiccolor),
                        onPressed: () {
                          if (validData()) {
                            // Register User WithOut OTP
                            initPlatformState();
                            registerUserWithOutOTP();
                          }
                        },
                        child: Text(
                          "SIGNUP".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('Already have an account ? '),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              welcomeRoute, ModalRoute.withName(welcomeRoute));
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            _loading
                ? const Center(
                    child: SpinKitCircle(size: 50, color: kPrimaryColorLight))
                : Container(),
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
                ))
          ],
        ),
      ),
    );
  }

  void setFocusListeners() {
    _nameFocus.requestFocus();
    _nameFocus.addListener(() {
      setState(() {});
    });
    _emailFocus.addListener(() {
      setState(() {});
    });
    _passwordFocus.addListener(() {
      setState(() {});
    });
    _phoneFocus.addListener(() {
      setState(() {});
    });

    setDateOnField();
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void setDateOnField() {
    _dobController.text = _selectedDate.year.toString() +
        '-' +
        _selectedDate.month.toString() +
        '-' +
        _selectedDate.day.toString();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1940),
        lastDate: DateTime.parse('2013-01-01'));
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      setDateOnField();
    }
  }

  bool validData() {
    if (_nameController.text.trim().isEmpty) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Please enter name');
      return false;
    }
    if (!isEmail(_emailController.text)) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Please enter a valid email');
      return false;
    }
    if (_passwordController.text.trim().length < 6) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Password should be at least 6 character long');
      return false;
    }
    return true;
  }

  List<DropdownMenuItem<String>> getDropDownCredibility() {
    return List.generate(
        credibility.length,
        (final index) => DropdownMenuItem(
              child: Text(credibility[index]),
              value: credibility[index],
            ));
  }

  bool validNumber() {
    if (_phoneController.text.trim().length < 5) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Please enter valid Number');
      return false;
    }
    return true;
  }

  void registerUserWithOutOTP() async {
    setState(() {
      _loading = true;
    });
    try {
      Map results = await NetworkHelper().registerUser(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        staticphoneNumber,
        _selectedCredibility,
        _selectedDate.toString(),
        device_id.toString(),
      );
      if (!results['error']) {
        UserModel user = results['user'];
        final _userData = Provider.of<UserProvider>(context, listen: false);
        _userData.user = user;
        await Prefs().setApiToken(user.apiToken);
        // Navigator.pushNamedAndRemoveUntil(
        //     context, homeRoute, ModalRoute.withName(welcomeRoute));
        Navigator.pushNamedAndRemoveUntil(
            context, getotpRoute, ModalRoute.withName(welcomeRoute));
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

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        device_id = deviceData['fingerprint'] ?? '';
        print(device_id);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        device_id = deviceData['identifierForVendor'] ?? '';
        print(deviceData);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
      // print('deviceData deviceData deviceData');
      // print(deviceData);
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'fingerprint': build.fingerprint,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'identifierForVendor': data.identifierForVendor,
    };
  }

  // void registerUser() async {
  //   setState(() {
  //     _loading = true;
  //   });
  //
  //   try {
  //     Map results = await NetworkHelper().registerUser(
  //       _nameController.text,
  //       _emailController.text,
  //       _phoneController.text,
  //       _passwordController.text,
  //       _selectedCredibility,
  //       _selectedDate.toString(),
  //     );
  //     if (!results['error']) {
  //       UserModel user = results['user'];
  //       final _userData = Provider.of<UserProvider>(context, listen: false);
  //       _userData.user = user;
  //       await Prefs().setApiToken(user.apiToken);
  //       await NetworkHelper().updateFirebaseToken();
  //       Navigator.pushNamedAndRemoveUntil(
  //           context, homeRoute, ModalRoute.withName(welcomeRoute));
  //     } else {
  //       SnackBarHelper.showSnackBarWithoutAction(context,
  //           message: results['errorData']);
  //     }
  //   } catch (e) {
  //     SnackBarHelper.showSnackBarWithoutAction(context, message: e.toString());
  //   }
  //   setState(() {
  //     _loading = false;
  //   });
  // }
}
