import 'dart:io';

import 'package:badges/badges.dart';
import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/text_fields_decorations.dart';
import 'package:briefify/helpers/file_picker_helper.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _qualificationController =
      TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _placeFocus = FocusNode();
  final FocusNode _qualificationFocus = FocusNode();
  final FocusNode _occupationFocus = FocusNode();

  XFile? _image;

  DateTime _selectedDate = DateTime.parse('2013-01-01');

  final List<String> credibility = ['Teacher', 'School', 'Business'];
  String _selectedCredibility = 'Teacher';
  bool _loading = false;

  @override
  void initState() {
    setFocusListeners();
    setPreviousValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserProvider>(context, listen: false);
    UserModel _user = _userData.user;
    return Scaffold(
      backgroundColor: kSecondaryColorDark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                  child: Text(
                    'Update Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                GestureDetector(
                    onTap: () async {
                      // Navigator.pushNamed(context, ProfileeImgScreen);
                    },
                    child: Badge(
                      badgeColor: kPrimaryColorLight,
                      // Select Image From gallery
                      badgeContent: GestureDetector(
                        onTap: () async {
                          XFile? file = await FilePickerHelper().getImage();
                          setState(() {
                            _image = file;
                          });
                        },
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                      position: BadgePosition.bottomEnd(),
                      padding: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        child: _image == null
                            ? ClipOval(
                                child: FadeInImage(
                                  placeholder: const AssetImage(userAvatar),
                                  image: NetworkImage(
                                    _user.image,
                                  ),
                                  height: 100.0,
                                  width: 100.0,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipOval(
                                child: Image.file(
                                  File(_image!.path),
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        backgroundColor: Colors.white,
                        radius: 50.0,
                      ),
                    )),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(
                      // left: !_nameFocus.hasFocus &&
                      //         !_emailFocus.hasFocus &&
                      //         !_passwordFocus.hasFocus &&
                      //         !_phoneFocus.hasFocus
                      //     ? 40
                      //     : _nameFocus.hasFocus
                      //         ? 40
                      //         : 80,
                      left: 40,
                      right: 40),
                  child: TextField(
                    controller: _nameController,
                    decoration: kAuthInputDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      hintText: 'Name',
                      fillColor: _passwordFocus.hasFocus ||
                              _emailFocus.hasFocus ||
                              _phoneFocus.hasFocus ||
                              _placeFocus.hasFocus ||
                              _qualificationFocus.hasFocus ||
                              _occupationFocus.hasFocus
                          ? Colors.grey.shade300
                          : Colors.white,
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _nameFocus,
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(
                      // left: !_nameFocus.hasFocus &&
                      //         !_emailFocus.hasFocus &&
                      //         !_passwordFocus.hasFocus &&
                      //         !_phoneFocus.hasFocus
                      //     ? 40
                      //     : _emailFocus.hasFocus
                      //         ? 40
                      //         : 80,
                      left: 40,
                      right: 40),
                  child: TextField(
                    controller: _emailController,
                    enabled: false,
                    decoration: kAuthInputDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      hintText: 'Email',
                      fillColor: _passwordFocus.hasFocus ||
                              _nameFocus.hasFocus ||
                              _phoneFocus.hasFocus ||
                              _placeFocus.hasFocus ||
                              _qualificationFocus.hasFocus ||
                              _occupationFocus.hasFocus
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
                  padding: const EdgeInsets.only(
                      // left: !_nameFocus.hasFocus &&
                      //         !_emailFocus.hasFocus &&
                      //         !_passwordFocus.hasFocus &&
                      //         !_phoneFocus.hasFocus
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
                      hintText: 'Password (if required)',
                      fillColor: _emailFocus.hasFocus ||
                              _nameFocus.hasFocus ||
                              _phoneFocus.hasFocus ||
                              _placeFocus.hasFocus ||
                              _qualificationFocus.hasFocus ||
                              _occupationFocus.hasFocus
                          ? Colors.grey.shade300
                          : Colors.white,
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _passwordFocus,
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(_placeFocus);
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(
                      // left: !_nameFocus.hasFocus &&
                      //         !_emailFocus.hasFocus &&
                      //         !_passwordFocus.hasFocus &&
                      //         !_phoneFocus.hasFocus
                      // ? 40
                      // : _phoneFocus.hasFocus
                      //     ? 40
                      //     : 80,
                      left: 40,
                      right: 40),
                  child: TextField(
                    enabled: false,
                    controller: _phoneController,
                    decoration: kAuthInputDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Colors.grey,
                      ),
                      hintText: 'Phone',
                      fillColor: _emailFocus.hasFocus ||
                              _nameFocus.hasFocus ||
                              _passwordFocus.hasFocus ||
                              _placeFocus.hasFocus ||
                              _qualificationFocus.hasFocus ||
                              _occupationFocus.hasFocus
                          ? Colors.grey.shade300
                          : Colors.white,
                    ),
                    focusNode: _phoneFocus,
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: TextField(
                    controller: _placeController,
                    decoration: kAuthInputDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.home,
                        color: Colors.grey,
                      ),
                      hintText: 'Lives in',
                      fillColor: _emailFocus.hasFocus ||
                              _nameFocus.hasFocus ||
                              _phoneFocus.hasFocus ||
                              _passwordFocus.hasFocus ||
                              _qualificationFocus.hasFocus ||
                              _occupationFocus.hasFocus
                          ? Colors.grey.shade300
                          : Colors.white,
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _placeFocus,
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(_qualificationFocus);
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: TextField(
                    controller: _qualificationController,
                    decoration: kAuthInputDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.school,
                        color: Colors.grey,
                      ),
                      hintText: 'Qualification',
                      fillColor: _emailFocus.hasFocus ||
                              _nameFocus.hasFocus ||
                              _phoneFocus.hasFocus ||
                              _passwordFocus.hasFocus ||
                              _placeFocus.hasFocus ||
                              _occupationFocus.hasFocus
                          ? Colors.grey.shade300
                          : Colors.white,
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _qualificationFocus,
                    onSubmitted: (v) {
                      FocusScope.of(context).requestFocus(_occupationFocus);
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: TextField(
                    controller: _occupationController,
                    decoration: kAuthInputDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.work,
                        color: Colors.grey,
                      ),
                      hintText: 'Occupation',
                      fillColor: _emailFocus.hasFocus ||
                              _nameFocus.hasFocus ||
                              _phoneFocus.hasFocus ||
                              _passwordFocus.hasFocus ||
                              _placeFocus.hasFocus ||
                              _qualificationFocus.hasFocus
                          ? Colors.grey.shade300
                          : Colors.white,
                    ),
                    textInputAction: TextInputAction.done,
                    focusNode: _occupationFocus,
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: GestureDetector(
                    onTap: () {
                      _selectDate();
                    },
                    child: TextField(
                      enabled: false,
                      controller: _dobController,
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
                    // left: !_nameFocus.hasFocus &&
                    //         !_emailFocus.hasFocus &&
                    //         !_passwordFocus.hasFocus &&
                    //         !_phoneFocus.hasFocus
                    //     ? 40
                    //     : 80,
                    left: 40,
                    right: 40,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      color: Colors.white),
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
                _loading
                    ? const Center(
                        child:
                            SpinKitCircle(size: 50, color: kPrimaryColorLight))
                    : ButtonOne(
                        title: 'Update',
                        onPressed: () {
                          if (validData()) {
                            updateUser();
                          }
                        },
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                const SizedBox(height: 20),
              ],
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
          ))
        ],
      ),
    );
  }

  void setDateOnField() {
    _dobController.text = _selectedDate.day.toString() +
        '-' +
        _selectedDate.month.toString() +
        '-' +
        _selectedDate.year.toString();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1940),
      lastDate: DateTime.parse('2013-01-01'),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      setDateOnField();
    }
  }

  List<DropdownMenuItem<String>> getDropDownCredibility() {
    return List.generate(
        credibility.length,
        (final index) => DropdownMenuItem(
              child: Text(credibility[index]),
              value: credibility[index],
            ));
  }

  void setPreviousValues() {
    final _userData = Provider.of<UserProvider>(context, listen: false);
    UserModel _user = _userData.user;
    _emailController.text = _user.email;
    _nameController.text = _user.name;
    _phoneController.text = _user.phone;
    _placeController.text = _user.city;
    _qualificationController.text = _user.qualification;
    _occupationController.text = _user.occupation;
    _selectedCredibility = _user.credibility;
    _dobController.text = _user.dob.split(' ')[0];
    _selectedDate = DateTime.parse(_user.dob);
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
    _placeFocus.addListener(() {
      setState(() {});
    });
    _qualificationFocus.addListener(() {
      setState(() {});
    });
    _occupationFocus.addListener(() {
      setState(() {});
    });
  }

  bool validData() {
    if (_nameController.text.isEmpty) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Please enter name');
      return false;
    }
    if (_passwordController.text.isNotEmpty &&
        _passwordController.text.length < 6) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Password should be at least 6 character long');
      return false;
    }
    if (_phoneController.text.isEmpty) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Please enter phone number');
      return false;
    }
    return true;
  }

  void updateUser() async {
    setState(() {
      _loading = true;
    });

    try {
      final _userData = Provider.of<UserProvider>(context, listen: false);
      Map<String, String> updates = {
        'api_token': _userData.user.apiToken,
        'name': _nameController.text.trim(),
        'phone': _phoneController.text,
        'credibility': _selectedCredibility,
        'dob': _selectedDate.toString(),
        'city': _placeController.text.toString().trim(),
        'qualification': _qualificationController.text.toString().trim(),
        'occupation': _occupationController.text.toString().trim(),
      };
      if (_passwordController.text.isNotEmpty) {
        updates['password'] = _passwordController.text;
      }
      Map results = await NetworkHelper().updateUser(_image, null, updates);
      if (!results['error']) {
        UserModel user = results['user'];
        _userData.user = user;
        await Prefs().setApiToken(user.apiToken);
        SnackBarHelper.showSnackBarWithoutAction(context, message: 'Updated');
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

