import 'package:briefify/data/constants.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/text_fields_decorations.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import 'package:intl/intl.dart';

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

  final List<String> credibility = ['Teacher', 'School', 'Business'];
  String _selectedCredibility = 'Teacher';
  String selectedCountryCode = '+1';
  bool _loading = false;
  String staticphoneNumber = '10000000000';
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 80, horizontal: 90),
                  child: Text(
                    'Create your account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: TextField(
                    maxLength: 20,
                    controller: _nameController,
                    decoration: kAuthInputDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      counterText: "",
                      hintText: 'Name',
                      fillColor: _passwordFocus.hasFocus ||
                              _emailFocus.hasFocus ||
                              _phoneFocus.hasFocus
                          ? Colors.grey.shade300
                          : Colors.white,
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _nameFocus,
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(_emailFocus);
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: kAuthInputDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      hintText: 'Email',
                      fillColor: _passwordFocus.hasFocus ||
                              _nameFocus.hasFocus ||
                              _phoneFocus.hasFocus
                          ? Colors.grey.shade300
                          : Colors.white,
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
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: kAuthInputDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.password,
                        color: Colors.grey,
                      ),
                      hintText: 'Password',
                      fillColor: _emailFocus.hasFocus ||
                              _nameFocus.hasFocus ||
                              _phoneFocus.hasFocus
                          ? Colors.grey.shade300
                          : Colors.white,
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _passwordFocus,
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(_phoneFocus);
                    },
                  ),
                ),
                // const SizedBox(height: 5),
                // Padding(
                //   padding: const EdgeInsets.only(
                //       // left: !_nameFocus.hasFocus &&
                //       //         !_emailFocus.hasFocus &&
                //       //         !_passwordFocus.hasFocus &&
                //       //         !_phoneFocus.hasFocus
                //       //     ? 40
                //       //     : _phoneFocus.hasFocus
                //       //         ? 40
                //       //         : 80,
                //       left: 40,
                //       right: 40),
                //   child: Row(
                //     children: [
                //       Container(
                //         height: 59,
                //         decoration: BoxDecoration(
                //           color: _emailFocus.hasFocus ||
                //                   _nameFocus.hasFocus ||
                //                   _passwordFocus.hasFocus
                //               ? Colors.grey.shade300
                //               : Colors.white,
                //           border: Border(
                //             top: BorderSide(
                //                 color: _emailFocus.hasFocus ||
                //                         _nameFocus.hasFocus ||
                //                         _passwordFocus.hasFocus
                //                     ? Colors.grey
                //                     : Colors.white),
                //             bottom: BorderSide(
                //                 color: _emailFocus.hasFocus ||
                //                         _nameFocus.hasFocus ||
                //                         _passwordFocus.hasFocus
                //                     ? Colors.grey
                //                     : Colors.white),
                //             left: BorderSide(
                //                 color: _emailFocus.hasFocus ||
                //                         _nameFocus.hasFocus ||
                //                         _passwordFocus.hasFocus
                //                     ? Colors.grey
                //                     : Colors.white),
                //             right: BorderSide(
                //                 color: _emailFocus.hasFocus ||
                //                         _nameFocus.hasFocus ||
                //                         _passwordFocus.hasFocus
                //                     ? Colors.grey.shade300
                //                     : Colors.grey),
                //           ),
                //         ),
                //         child: CountryCodePicker(
                //           showFlagMain: false,
                //           initialSelection: 'US',
                //           onChanged: (CountryCode code) {
                //             if (code.dialCode != null) {
                //               selectedCountryCode = code.dialCode!;
                //             }
                //           },
                //         ),
                //       ),
                //       Flexible(
                //         child: TextField(
                //           controller: _phoneController,
                //           keyboardType: TextInputType.phone,
                //           decoration: kAuthInputDecoration.copyWith(
                //             prefixIcon: const Icon(
                //               Icons.phone,
                //               color: Colors.grey,
                //             ),
                //             hintText: 'Phone (optional)',
                //             fillColor: _emailFocus.hasFocus ||
                //                     _nameFocus.hasFocus ||
                //                     _passwordFocus.hasFocus
                //                 ? Colors.grey.shade300
                //                 : Colors.white,
                //           ),
                //           focusNode: _phoneFocus,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(
                      // left: !_nameFocus.hasFocus &&
                      //         !_emailFocus.hasFocus &&
                      //         !_passwordFocus.hasFocus &&
                      //         !_phoneFocus.hasFocus
                      //     ? 40
                      //     : 80,
                      left: 40,
                      right: 40),
                  child: GestureDetector(
                    onTap: () {
                      _selectDate();
                    },
                    child: TextField(
                      controller: _dobController,
                      enabled: false,
                      decoration: kAuthInputDecoration.copyWith(
                        prefixIcon: const Icon(
                          Icons.cake,
                          color: Colors.grey,
                        ),
                        hintText: 'DOB',
                        fillColor: _emailFocus.hasFocus ||
                                _nameFocus.hasFocus ||
                                _passwordFocus.hasFocus ||
                                _phoneFocus.hasFocus
                            ? Colors.grey.shade300
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  margin: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
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
                ButtonOne(
                  title: 'Register',
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, getotpRoute,
                        ModalRoute.withName(welcomeRoute));
                    // if (_phoneController.text.isEmpty) {
                    // if (validData()) {
                    //   // Register User WithOut OTP
                    //   registerUserWithOutOTP();

                    // }
                    //}
                    // else {
                    //   if (validData()) {
                    //     if (validNumber()) {
                    //       Navigator.pushNamed(context, otpRoute, arguments: {
                    //         'name': _nameController.text,
                    //         'email': _emailController.text,
                    //         'phoneNumber':
                    //             selectedCountryCode + _phoneController.text,
                    //         'password': _passwordController.text,
                    //         'credibility': _selectedCredibility,
                    //         'date': _selectedDate.toString(),
                    //       });
                    //     }
                    //   }
                    // }
                  },
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          _loading
              ? const Center(
                  child: SpinKitCircle(size: 50, color: kPrimaryColorLight))
              : Container(),
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
          ))
        ],
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
        staticphoneNumber,
        _passwordController.text.trim(),
        _selectedCredibility,
        _selectedDate.toString(),
      );
      if (!results['error']) {
        UserModel user = results['user'];
        final _userData = Provider.of<UserProvider>(context, listen: false);
        _userData.user = user;
        await Prefs().setApiToken(user.apiToken);
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
