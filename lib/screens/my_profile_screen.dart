import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/urls.dart';
import 'package:briefify/helpers/file_picker_helper.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/post_model.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/home_posts_provider.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/post_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool _loading = false;
  bool _updatingCover = false;
  XFile? _coverImage;
  bool _error = false;
  int currentPage = 0;
  int lastPage = 1;
  String nextPageURL = uGetUserPosts;
  final _pageScrollController = ScrollController();
  final List<PostModel> _posts = List.empty(growable: true);
  bool playaudio = true;

  @override
  void initState() {
    print('My profile Screen is Here');
    getHomePosts();
    setScrollControllerListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Posts provider
    final _postsData = Provider.of<HomePostsProvider>(context);
    final _userData = Provider.of<UserProvider>(context);
    final user = _userData.user;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: NestedScrollView(
      floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Column(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.pushNamed(context, ImgeScreen);
                          },
                          child: FadeInImage(
                            placeholder: const AssetImage(cover),
                            image: NetworkImage(
                              user.cover,
                            ),
                            height: 150.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 100, width: double.infinity),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, updateProfileRoute);
                              },
                              child: Badge(
                                badgeColor: kPrimaryColorLight,
                                badgeContent: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                position: BadgePosition.bottomEnd(),
                                padding: const EdgeInsets.all(10),
                                child: ClipOval(
                                  child: FadeInImage(
                                    placeholder: const AssetImage(userAvatar),
                                    image: NetworkImage(
                                      user.image,
                                    ),
                                    height: 100.0,
                                    width: 100.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              if (!_updatingCover) {
                                _coverImage = await FilePickerHelper().getImage();
                                if (_coverImage != null) {
                                  updateCoverPicture();
                                }
                              }
                            },
                            child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 15),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: kPrimaryColorLight,
                                  borderRadius: BorderRadius.circular(200),
                                ),
                                child: _updatingCover
                                    ? const SpinKitCircle(
                                  size: 20,
                                  color: Colors.white,
                                )
                                    : const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                )),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      user.name,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: kPrimaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user.userFollowers.toString() +
                          ' Followers - ' +
                          user.userFollowing.toString() +
                          ' Following',
                      style: const TextStyle(color: kPrimaryTextColor),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, followersRoute,
                                arguments: {'user': user});
                          },
                          child: Column(
                            children: const [
                              Icon(
                                Icons.people,
                                size: 30,
                                color: kPrimaryTextColor,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Followers',
                                style: TextStyle(
                                  color: kPrimaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, followingRoute,
                                arguments: {'user': user});
                          },
                          child: Column(
                            children: const [
                              Icon(
                                Icons.groups,
                                size: 30,
                                color: kPrimaryTextColor,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Following',
                                style: TextStyle(
                                  color: kPrimaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                  ],
                );
              },
              childCount: 1,
            ),
          ),
        ],
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// From Here below are Users Posts
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(height: 10,
                          color: const Color(0xffEDF0F4),),
                        ListView.builder(
                          controller: _pageScrollController,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => index == _posts.length &&
                                  nextPageURL.isNotEmpty
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
                              : PostCard( //here
                                  post: _posts[index],
                                  isMyPost: true,
                                  playAudio: () {
                                    var myJSON = jsonDecode(_posts[index].summary.toString());
                                    quil.Document doc =
                                        quil.Document.fromJson(myJSON);
                                    speak(doc.toPlainText());
                                  },
                                  deletePost: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: const Text('Delete Post'),
                                            actions: [
                                              CupertinoDialogAction(
                                                child: const Text('No'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              CupertinoDialogAction(
                                                child: const Text('Yes'),
                                                isDefaultAction: true,
                                                isDestructiveAction: true,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  NetworkHelper().deletePost(
                                                      _posts[index].id.toString());
                                                  setState(() {
                                                    _posts.removeAt(index);
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                          itemCount:
                              nextPageURL.isEmpty ? _posts.length : _posts.length + 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),),
          Positioned(
              child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: kPrimaryColorLight,
                  borderRadius: BorderRadius.circular(200),
                ),
                child: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                )),
          )),
        ],
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
        final _userData = Provider.of<UserProvider>(context, listen: false);
        final user = _userData.user;
        Map results =
            await NetworkHelper().getUserPosts(nextPageURL, user.id.toString());
        print('abc+$user');
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
        print('we are at bottom');

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

  void updateCoverPicture() async {
    setState(() {
      _updatingCover = true;
    });

    try {
      final _userData = Provider.of<UserProvider>(context, listen: false);
      Map<String, String> updates = {
        'api_token': _userData.user.apiToken,
      };
      Map results =
          await NetworkHelper().updateUser(null, _coverImage, updates);
      if (!results['error']) {
        UserModel user = results['user'];
        _userData.user = user;
        await Prefs().setApiToken(user.apiToken);
        SnackBarHelper.showSnackBarWithoutAction(context,
            message: 'Cover updated');
      } else {
        _coverImage = null;
        SnackBarHelper.showSnackBarWithoutAction(context,
            message: results['errorData']);
      }
    } catch (e) {
      _coverImage = null;
      SnackBarHelper.showSnackBarWithoutAction(context, message: e.toString());
    }
    setState(() {
      _updatingCover = false;
    });
  }

  void speak(String text) async {
    FlutterTts flutterTts = FlutterTts();
    if (Platform.isIOS) {
      await flutterTts.setSharedInstance(true);
    }
    if (playaudio == false) {
      await flutterTts.stop();
      playaudio = true;
    } else {
      playaudio = false;
      var result = await flutterTts.speak(text);
    }
  }
}

