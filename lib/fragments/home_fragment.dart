import 'dart:convert';
import 'dart:io';

import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/urls.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/models/post_model.dart';
import 'package:briefify/providers/home_posts_provider.dart';
import 'package:briefify/providers/post_observer_provider.dart';
import 'package:briefify/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  void initState() {
    print('home screen is here');
    refreshPosts();
    setScrollControllerListener();
    super.initState();
  }

  bool _loading = false;
  bool _error = false;
  int currentPage = 0;
  int lastPage = 1;
  String nextPageURL = uGetHomePosts;
  final _pageScrollController = ScrollController();
  bool playaudio = true;

  @override
  Widget build(BuildContext context) {
    /// Posts provider
    final _postsData = Provider.of<HomePostsProvider>(context);
    List<PostModel> _posts = _postsData.homePosts;

    /// new posts observer
    final _postObserverData = Provider.of<PostObserverProvider>(context);
    final int count = _postObserverData.newPostCount;
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: _posts.isEmpty && !_loading && !_error
            ? Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        refreshPosts();
                      },
                      icon: const Icon(Icons.refresh),
                      iconSize: 30,
                      color: kSecondaryTextColor,
                    ),
                    const Text('No Posts To Show'),
                  ],
                ))
            : Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: refreshPosts,
                    child: ListView.builder(
                      controller: _pageScrollController,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          index == _posts.length && nextPageURL.isNotEmpty
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
                                    var myJSON =
                                        jsonDecode(_posts[index].summary);
                                    quil.Document doc =
                                        quil.Document.fromJson(myJSON);
                                    speak(doc.toPlainText());
                                  },
                                ),
                      itemCount: nextPageURL.isEmpty
                          ? _posts.length
                          : _posts.length + 1,
                    ),
                  ),
                  if (count > 7)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          padding: const EdgeInsets.all(0),
                          height: 28,
                          onPressed: () {
                            refreshPosts();
                          },
                          child: const Text(
                            'New Posts',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          color: kPrimaryColorDark,
                          textColor: Colors.white,
                        ),
                      ],
                    )
                ],
              ),
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
        Map results = await NetworkHelper().getHomePosts(nextPageURL);
        if (!results['error']) {
          currentPage = results['currentPage'];
          lastPage = results['lastPage'];
          nextPageURL = results['nextPageURL'];
          final posts = results['posts'];
          final _postsData =
              Provider.of<HomePostsProvider>(context, listen: false);
          _postsData.addAllPosts(posts);
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

  Future<void> refreshPosts() async {
    _error = await false;
    resetNewPostsCount();
    nextPageURL = uGetHomePosts;
    final _postsData = Provider.of<HomePostsProvider>(context, listen: false);
    _postsData.homePosts = List.empty(growable: true);
    setState(() {
      _loading = true;
    });
    try {
      Map results = await NetworkHelper().getHomePosts(nextPageURL);
      if (!results['error']) {
        currentPage = results['currentPage'];
        lastPage = results['lastPage'];
        nextPageURL = results['nextPageURL'];
        final posts = results['posts'];
        final _postsData =
            Provider.of<HomePostsProvider>(context, listen: false);
        _postsData.addAllPosts(posts);
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

  void resetNewPostsCount() {
    final _postObserverData =
        Provider.of<PostObserverProvider>(context, listen: false);
    _postObserverData.resetCount();
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

  // Todo Speaking Function
  void speak(String text) async {
    print('speaking');
    FlutterTts flutterTts = FlutterTts();
    if (Platform.isIOS) {
      if (playaudio == false) {
        await flutterTts.stop();
        playaudio = true;
      } else {
        playaudio = false;
        await flutterTts.setSharedInstance(true);
      }
    }
    if (playaudio == false) {
      await flutterTts.stop();
      playaudio = true;
    } else {
      playaudio = false;
      await flutterTts.speak(text);
    }
  }
}
