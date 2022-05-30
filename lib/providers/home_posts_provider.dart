import 'package:briefify/helpers/admob_helper.dart';
import 'package:briefify/models/post_model.dart';
import 'package:flutter/cupertino.dart';

class HomePostsProvider extends ChangeNotifier {
  List<dynamic> _homePosts = List.empty(growable: true);

  List<dynamic> get homePosts => _homePosts;

  set homePosts(List<dynamic> value) {
    _homePosts = value;
    notifyListeners();
  }

  void addPost(PostModel post) {
    _homePosts.add(post);
    notifyListeners();
  }

  void updateChanges() {
    notifyListeners();
  }

  void addAllPosts(List<dynamic> posts) {
    _homePosts.addAll(posts);
    // print(posts.length.toString());
    // for (int i = 6; i < 300; i+=6) {
    //   _homePosts.insert(i, AdMobHelper.loadNativeAd()..load());
    // }
    notifyListeners();
  }
}


class ArtPostsProvider extends ChangeNotifier {
  List<dynamic> _artPosts = List.empty(growable: true);

  List<dynamic> get artPosts => _artPosts;

  set artPosts(List<dynamic> value) {
    _artPosts = value;
    notifyListeners();
  }

  void addPost(PostModel post) {
    _artPosts.add(post);
    notifyListeners();
  }

  void updateChanges() {
    notifyListeners();
  }

  void addAllArts(List<dynamic> posts) {
    _artPosts.addAll(posts);
    // for (int i = 0; i < 100; i+=6) {
    //     _artPosts.insert(i, AdMobHelper.loadNativeAd()..load());
    // }
    notifyListeners();
  }
}