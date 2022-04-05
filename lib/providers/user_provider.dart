import 'package:briefify/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(0, 'name', 'email', 'phone', 'credibility', 'dob', 'apiToken', 0, 0, 0, 'image',
      'cover', '', '', '', 0, 0, false);

  UserModel get user => _user;

  set user(UserModel value) {
    _user = value;
    notifyListeners();
  }
}

