import 'package:briefify/models/category_model.dart';
import 'package:briefify/models/post_model.dart';
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

class PostProvider extends ChangeNotifier {
  PostModel _postModel = PostModel(CategoryModel(0,'name'), 'heading', 'summary', 'videoLink', 'type', 'art_image', 'pdf', 0, 'timeStamp', 'articleLink',
      UserModel(0, 'name', 'email', 'phone', 'credibility', 'dob', 'apiToken', 0, 0, 0, 'image',
          'cover', '', '', '', 0, 0, false),
      0, 0, 0, false, false);
  PostModel get post => _postModel;
  set post(PostModel value) {
    _postModel = value;
    notifyListeners();
  }
}

