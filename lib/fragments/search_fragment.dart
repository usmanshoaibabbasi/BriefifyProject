import 'dart:convert';
import 'dart:io';

import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/text_fields_decorations.dart';
import 'package:briefify/data/urls.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/models/post_model.dart';
import 'package:briefify/providers/home_posts_provider.dart';
import 'package:briefify/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

class SearchFragment extends StatefulWidget {
  const SearchFragment({Key? key}) : super(key: key);

  @override
  State<SearchFragment> createState() => _SearchFragmentState();
}

class _SearchFragmentState extends State<SearchFragment> {
  final TextEditingController _searchTextController = TextEditingController();
  List<PostModel> _posts = List.empty(growable: true);
  bool _loading = false;
  bool _error = false;
  bool _searching = false;
  bool _searchError = false;
  int currentPage = 0;
  int lastPage = 1;
  String nextPageURL = uSearchPost;
  final _pageScrollController = ScrollController();
  String _currentKeyword = '';

  @override
  void initState() {
    setScrollControllerListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Posts provider
    final _postsData = Provider.of<HomePostsProvider>(context);
    return Column(
      children: [
        Container(height: 10,
          color: const Color(0xffEDF0F4),),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          margin: const EdgeInsets.only(bottom: 10),
          child: TextField(
            controller: _searchTextController,
            textInputAction: TextInputAction.search,
            decoration: kSearchInputDecoration.copyWith(
              hintText: 'Search Briefify',
              isDense: true,
            ),
            onSubmitted: (String value) {
              if (value.isNotEmpty) {
                _currentKeyword = value;
                nextPageURL = uSearchPost;
                searchPosts();
              }
            },
          ),
        ),
        Container(
          color: Colors.white,
          child: _searching
              ? const SpinKitCircle(
                  size: 50,
                  color: kPrimaryColorLight,
                )
              : _searchError
                  ? Center(
                      child: GestureDetector(
                          onTap: () {
                            searchPosts();
                          },
                          child: Image.asset(
                            errorIcon,
                            height: 80,
                          )))
                  : _posts.isEmpty && !_loading && !_error
                      ? Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: const Text('No Search Results'))
                      : ListView.builder(
                          shrinkWrap: true,
                          controller: _pageScrollController,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) =>
                              index == _posts.length && nextPageURL.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: _error
                                          ? GestureDetector(
                                              onTap: () {},
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
                          itemCount: _posts.length,
                        ),
        )
      ],
    );
  }

  void searchPosts() async {
    _error = await false;
    _searchError = false;
    setState(() {
      _loading = true;
      _searching = true;
    });
    try {
      Map results = await NetworkHelper().searchPosts(nextPageURL, _currentKeyword);
      if (!results['error']) {
        currentPage = results['currentPage'];
        lastPage = results['lastPage'];
        nextPageURL = results['nextPageURL'];
        _posts = results['posts'];
      } else {
        _error = true;
        _searchError = true;
      }
    } catch (e) {
      _error = true;
      _searchError = true;
    }
    setState(() {
      _loading = false;
      _searching = false;
    });
  }

  void searchMorePosts() async {
    if (!_loading && nextPageURL.isNotEmpty) {
      _error = await false;
      setState(() {
        _loading = true;
      });
      try {
        Map results = await NetworkHelper().searchPosts(nextPageURL, _currentKeyword);
        if (!results['error']) {
          currentPage = results['currentPage'];
          lastPage = results['lastPage'];
          nextPageURL = results['nextPageURL'];
          final posts = results['posts'];
          _posts.addAll(posts);
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
          searchMorePosts();
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
