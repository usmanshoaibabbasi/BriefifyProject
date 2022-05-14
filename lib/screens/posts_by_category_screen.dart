import 'dart:convert';
import 'dart:io';

import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/urls.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/models/category_model.dart';
import 'package:briefify/models/post_model.dart';
import 'package:briefify/providers/home_posts_provider.dart';
import 'package:briefify/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

class PostsByCategoryScreen extends StatefulWidget {
  const PostsByCategoryScreen({Key? key, required this.category}) : super(key: key);
  final CategoryModel category;

  @override
  _PostsByCategoryScreenState createState() => _PostsByCategoryScreenState();
}

class _PostsByCategoryScreenState extends State<PostsByCategoryScreen> {
  bool _loading = false;
  bool _error = false;
  int currentPage = 0;
  int lastPage = 1;
  String nextPageURL = uGetPostsByCategory;
  final _pageScrollController = ScrollController();
  final List<PostModel> _posts = List.empty(growable: true);

  @override
  void initState() {
    getHomePosts();
    setScrollControllerListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Posts provider
    final _postsData = Provider.of<HomePostsProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            appLogo,
            height: 50,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: kPrimaryColorLight,
                borderRadius: BorderRadius.circular(200),
              ),
              child: const Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              )),
          onPressed: () {
            Navigator.pop(context);
          },
          color: kSecondaryColorDark,
          padding: const EdgeInsets.all(0),
        ),
      ),
      body: _posts.isEmpty && !_loading && !_error
          ? Container(
              alignment: Alignment.center, width: double.infinity, child: const Text('No Posts To Show'))
          : ListView.builder(
              controller: _pageScrollController,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => index == _posts.length && nextPageURL.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: _error
                          ? GestureDetector(
                              onTap: () {
                                getHomePosts();
                              },
                              child: Image.asset(
                                errorIcon,
                                height: 40,
                              ))
                          : const SpinKitCircle(
                              size: 50,
                              color: kPrimaryColorLight,
                            ),
                    )
                  : PostCard(
                      post: _posts[index],
                      playAudio: () {
                        var myJSON = jsonDecode(_posts[index].summary.toString());
                        quil.Document doc = quil.Document.fromJson(myJSON);
                        speak(doc.toPlainText());
                      },
                    ),
              itemCount: nextPageURL.isEmpty ? _posts.length : _posts.length + 1,
            ),
    );
  }

  void getHomePosts() async {
    if (!_loading && nextPageURL.isNotEmpty) {
      _error = await false;
      setState(() {
        _loading = true;
      });
      try {
        Map results = await NetworkHelper().getPostsByCategory(nextPageURL, widget.category.id.toString());
        if (!results['error']) {
          currentPage = results['currentPage'];
          lastPage = results['lastPage'];
          nextPageURL = results['nextPageURL'];
          List<PostModel> newPosts = results['posts'];
          _posts.addAll(newPosts);
        } else {
          _error = true;
        }
      } catch (e) {
        _error = true;
      }
      setState(() {
        _loading = false;
      });
    }
  }

  void setScrollControllerListener() {
    _pageScrollController.addListener(() async {
      double maxScroll = _pageScrollController.position.maxScrollExtent;
      double currentScroll = _pageScrollController.position.pixels;
      if (maxScroll - currentScroll == 0) {
        /// we're at the bottom
        if (nextPageURL.isNotEmpty) {
          getHomePosts();
        } else {
          setState(() {
            _loading = false;
          });
        }
      }
    });
  }

  void speak(String text) async {
    FlutterTts flutterTts = FlutterTts();
    if (Platform.isIOS) {
      await flutterTts.setSharedInstance(true);
    }
    var result = await flutterTts.speak(text);
  }
}
