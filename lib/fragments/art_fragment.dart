import 'package:briefify/providers/home_posts_provider.dart';
import 'package:briefify/widgets/art_card.dart';
import 'package:briefify/widgets/shimmer%20effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'dart:convert';
import 'dart:io';

import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/urls.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/models/post_model.dart';
import 'package:briefify/providers/post_observer_provider.dart';
import 'package:briefify/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ArtFragment extends StatefulWidget {
  const ArtFragment({Key? key}) : super(key: key);

  @override
  State<ArtFragment> createState() => _ArtFragmentState();
}

class _ArtFragmentState extends State<ArtFragment> {
  late List<dynamic> _arts;
  late NativeAd _ad;
  bool isLoaded = false;
  @override
  void initState() {
    print('home screen is here');
    refreshArts();
    setScrollControllerListener();
    loadNativeAd();
    super.initState();
  }
  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }
  void loadNativeAd() {
    _ad = NativeAd(
        request: const AdRequest(),
        ///This is a test adUnitId make sure to change it
        adUnitId: 'ca-app-pub-3940256099942544/2247696110',
        //adUnitId: 'ca-app-pub-1721909976834129/3168498284',
        factoryId: 'listTile',
        listener: NativeAdListener(
            onAdLoaded: (ad){
              setState(() {
                isLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, error){
              ad.dispose();
              print('failed to load the ad ${error.message}, ${error.code}');
            }
        )
    );

    _ad.load();
  }


  bool _loading = false;
  bool _error = false;
  int currentPage = 0;
  int lastPage = 1;
  String nextPageURL = uGetHomeArts;
  final _pageScrollController = ScrollController();
  bool playaudio = true;

  Widget build(BuildContext context) {
    /// Posts provider
    final _artsData = Provider.of<ArtPostsProvider>(context);
    _arts = _artsData.artPosts;

    /// new posts observer
    final _postObserverData = Provider.of<ArtObserverProvider>(context);
    final int count = _postObserverData.newPostCount;
    final double _width = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(color: Color(0XffEDF0F4),),
      child: _arts.isEmpty && !_loading && !_error
          ? Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: Column(
            children: [
              IconButton(
                onPressed: () {
                  refreshArts();
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
            onRefresh: refreshArts,
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              controller: _pageScrollController,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
              index == _arts.length && nextPageURL.isNotEmpty
                  ?
              Padding(
                padding: const EdgeInsets.all(10),
                child: _error
                    ? GestureDetector(
                  onTap: () {
                    getHomeArts();
                    print('_posts');
                    print(_arts);
                    print('_postsData');
                    print(_artsData);
                  },
                  child: Image.asset(
                    errorIcon,
                    height: 40,
                  ),
                )
                    :
                ListView.builder(
                  controller: _pageScrollController,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  primary: false,
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return shimmereffect(context: context);
                  },
                ),
              )
                  :
              // _arts[index] is NativeAd ?
              // Container(
              //   decoration: const BoxDecoration(
              //     color: Color(0xffFFFFFF),
              //     borderRadius: BorderRadius.all(Radius.circular(20),
              //     ),
              //   ),
              //   margin: const EdgeInsets.fromLTRB(8, 0, 8, 15),
              //   height: 190,
              //   child: AdWidget(
              //     ad: _arts[index] as NativeAd,
              //     key: UniqueKey(),
              //   ),
              // ):
              isLoaded && index == 2 ?
              Container(
                height: 350,
                  margin: const EdgeInsets.fromLTRB(8, 0, 8, 15),
                  decoration: const BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(20),
                    ),
                  ),
                child: AdWidget(
                  ad: _ad,
                  key: UniqueKey(),
                ),
                alignment: Alignment.center,
              ):
              ArtCard(
                post: _arts[index],
              ),
              itemCount: nextPageURL.isEmpty
                  ? _arts.length
                  : _arts.length + 1,
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
                    refreshArts();
                  },
                  child: const Text(
                    'New Arts',
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
    );
  }

  void getHomeArts() async {
    if (!_loading && nextPageURL.isNotEmpty) {
      _error = false;
      setState(() {
        _loading = true;
      });
      try {
        Map results = await NetworkHelper().getHomeArts(nextPageURL);
        print('results results');
        print(results);
        if (!results['error']) {
          currentPage = results['currentPage'];
          lastPage = results['lastPage'];
          nextPageURL = results['nextPageURL'];
          final posts = results['posts'];
          print('posts');
          final _postsData =
          Provider.of<ArtPostsProvider>(context, listen: false);
          _postsData.addAllArts(posts);
        } else {
          print('error true');
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
  Future<void> refreshArts() async {
    _error = false;
    resetNewPostsCount();
    nextPageURL = uGetHomeArts;
    final _postsData = Provider.of<ArtPostsProvider>(context, listen: false);
    _postsData.artPosts = List.empty(growable: true);
    setState(() {
      _loading = true;
    });
    try {
      Map results = await NetworkHelper().getHomeArts(nextPageURL);
      if (!results['error']) {
        currentPage = results['currentPage'];
        lastPage = results['lastPage'];
        nextPageURL = results['nextPageURL'];
        final posts = results['posts'];
        final _postsData =
        Provider.of<ArtPostsProvider>(context, listen: false);
        _postsData.addAllArts(posts);
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
    Provider.of<ArtObserverProvider>(context, listen: false);
    _postObserverData.resetCount();
  }

  void setScrollControllerListener() {
    _pageScrollController.addListener(() async {
      double maxScroll = _pageScrollController.position.maxScrollExtent;
      double currentScroll = _pageScrollController.position.pixels;
      if (maxScroll - currentScroll == 0) {
        /// we're at the bottom
        if (nextPageURL.isNotEmpty) {
          getHomeArts();
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
