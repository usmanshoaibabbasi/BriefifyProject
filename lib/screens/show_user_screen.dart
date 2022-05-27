import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/urls.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/models/post_model.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/widgets/post_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

class ShowUserScreen extends StatefulWidget {
  final UserModel user;
  const ShowUserScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _ShowUserScreenState createState() => _ShowUserScreenState();
}

class _ShowUserScreenState extends State<ShowUserScreen> {
  bool _loading = false;
  bool playaudio = true;
  bool _error = false;
  int currentPage = 0;
  int lastPage = 1;
  String nextPageURL = uGetUserPosts;
  final _pageScrollController = ScrollController();
  final List<PostModel> _posts = List.empty(growable: true);

  @override
  void initState() {
    print('Show user screen');
    // print(widget.user.name.toString());
    // print(widget.user.dob.toString());
    // print(widget.user.phone.toString());
    // print(widget.user.email.toString());
    // print(widget.user.occupation);
    // print(widget.user.qualification.toString());
    getHomePosts();
    setScrollControllerListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Posts provider
    return Scaffold(
      backgroundColor: const Color(0xffEDF0F4),
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
                            var modelSendToshowimg = widget.user;
                            Navigator.pushNamed(context, OtherUserCoverImg,
                                arguments: {'user': modelSendToshowimg});
                          },
                          child: FadeInImage(
                            placeholder: const AssetImage(cover),
                            image: NetworkImage(
                              widget.user.cover,
                            ),
                            height: 140.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 80, width: double.infinity),
                            Badge(
                              badgeContent: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                              showBadge: widget.user.badgeStatus == 2,
                              position: BadgePosition.bottomEnd(bottom: 0, end: 0),
                              badgeColor: kPrimaryColorLight,
                              child: ClipOval(
                                child: GestureDetector(
                                  onTap: () {
                                    var modelSendToshowimg = widget.user;
                                    Navigator.pushNamed(
                                        context, OtherUserProfileImg,
                                        arguments: {'user': modelSendToshowimg});
                                  },
                                  child: FadeInImage(
                                    placeholder: const AssetImage(userAvatar),
                                    image: NetworkImage(
                                      widget.user.image,
                                    ),
                                    height: 95.0,
                                    width: 95.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            widget.user.name,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: kPrimaryTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.user.userFollowers.toString() +
                                ' Followers - ' +
                                widget.user.userFollowing.toString() +
                                ' Following',
                            style:
                            const TextStyle(color: kPrimaryTextColor, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (widget.user.isFollowing) {
                                    NetworkHelper()
                                        .unfollowUser(widget.user.id.toString());
                                  } else {
                                    NetworkHelper().followUser(widget.user.id.toString());
                                  }
                                  setState(() {
                                    widget.user.isFollowing = !widget.user.isFollowing;
                                  });
                                  Map results =
                                  await NetworkHelper().updateFirebaseToken();
                                  if (!results['error']) {
                                    UserModel _user = results['user'];
                                    final _userData =
                                    Provider.of<UserProvider>(context, listen: false);
                                    _userData.user = _user;
                                  }
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: widget.user.isFollowing
                                          ? kPrimaryColorLight
                                          : kTextColorLightGrey,
                                      size: 26,
                                    ),
                                    const SizedBox(height: 3),
                                    const Text(
                                      'Follow',
                                      style: TextStyle(
                                          color: kPrimaryTextColor, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, followersRoute,
                                      arguments: {'user': widget.user});
                                },
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.people,
                                      size: 26,
                                      color: kPrimaryTextColor,
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                          color: kPrimaryTextColor, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, followingRoute,
                                      arguments: {'user': widget.user});
                                },
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.groups,
                                      size: 26,
                                      color: kPrimaryTextColor,
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Following',
                                      style: TextStyle(
                                          color: kPrimaryTextColor, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (widget.user.city.isNotEmpty)
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.home,
                                  color: kPrimaryTextColor,
                                ),
                                const Text(
                                  '  Lives in ',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.user.city,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: kPrimaryTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (widget.user.qualification.isNotEmpty)
                            const SizedBox(height: 5),
                          if (widget.user.qualification.isNotEmpty)
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.school,
                                  color: kPrimaryTextColor,
                                ),
                                const Text(
                                  '  Qualification ',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.user.qualification,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: kPrimaryTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (widget.user.occupation.isNotEmpty)
                            const SizedBox(height: 5),
                          if (widget.user.occupation.isNotEmpty)
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.work,
                                  color: kPrimaryTextColor,
                                ),
                                const Text(
                                  '  Occupation ',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Expanded(
                                  child: Text(
                                    widget.user.occupation,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: kPrimaryTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                );
              },
              childCount: 1,
            ),
          ),
        ],
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10,),
                        _posts.isEmpty && !_loading && !_error
                            ? Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                child: const Text(
                                  'No Posts To Show',
                                  style: TextStyle(color: kSecondaryTextColor),
                                ))
                            : ListView.builder(
                                controller: _pageScrollController,
                                shrinkWrap: true,
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
                                                  jsonDecode(_posts[index].summary.toString());
                                              quil.Document doc =
                                                  quil.Document.fromJson(myJSON);
                                              speak(doc.toPlainText());
                                            },
                                          ),
                                itemCount: nextPageURL.isEmpty
                                    ? _posts.length
                                    : _posts.length + 1,
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
        Map results = await NetworkHelper()
            .getUserPosts(nextPageURL, widget.user.id.toString());
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
    if (playaudio == false) {
      await flutterTts.stop();
      playaudio = true;
    } else {
      playaudio = false;
    }
  }
}
