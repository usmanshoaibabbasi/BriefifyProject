import 'package:flutter/cupertino.dart';

class PostObserverProvider extends ChangeNotifier {
  int _newPostCount = 0;

  resetCount() {
    _newPostCount = 0;
    notifyListeners();
  }

  incrementCount() {
    _newPostCount++;
    notifyListeners();
  }

  int get newPostCount => _newPostCount;
}
