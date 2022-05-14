import 'package:briefify/models/post_model.dart';
import 'package:flutter/cupertino.dart';

class HomePostsProvider extends ChangeNotifier {
  List<PostModel> _homePosts = List.empty(growable: true);

  List<PostModel> get homePosts => _homePosts;

  set homePosts(List<PostModel> value) {
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

  void addAllPosts(List<PostModel> posts) {
    _homePosts.addAll(posts);
    notifyListeners();
  }
}


class ArtPostsProvider extends ChangeNotifier {
  List<PostModel> _artPosts = List.empty(growable: true);

  List<PostModel> get artPosts => _artPosts;

  set artPosts(List<PostModel> value) {
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

  void addAllArts(List<PostModel> posts) {
    _artPosts.addAll(posts);
    notifyListeners();
  }
}