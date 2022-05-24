import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/edit_post_argument.dart';
import 'package:briefify/models/post_model.dart';
import 'package:briefify/models/route_argument.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/home_posts_provider.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/screens/urlpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class PostDetail extends StatefulWidget {
  final PostModel postModel;
  final VoidCallback? deletePost;
  // final VoidCallback playAudio;
  final bool isMyPost;
  const PostDetail({
    Key? key,
    required this.postModel,
    // required this.playAudio,
    this.deletePost,
    this.isMyPost = false
  }) : super(key: key);

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  var result1;
  late int whoblocked;
  late int whomblocked;
  bool _loading = false;
  bool playaudio = true;

  @override
  void initState() {
    print(widget.postModel.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserProvider>(context, listen: false);
    final myUser = _userData.user;
    final int userId = myUser.id as int;
    final int postId = widget.postModel.id as int;
    final String heading = widget.postModel.heading as String;
    final String summary = widget.postModel.summary as String;
    final String videolink = widget.postModel.videoLink as String;
    final String ariclelink = widget.postModel.articleLink as String;

    var myJSON = jsonDecode(widget.postModel.summary.toString());
    final quil.QuillController _summaryController = quil.QuillController(
      document: quil.Document.fromJson(myJSON),
      selection: const TextSelection.collapsed(offset: 0),
    );
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Container(
              padding: const EdgeInsets.fromLTRB(0, 50, 10, 15),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                        color: kTextColorLightGrey,
                        width: 0.7,
                      ))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context,
                                    myUser.id == widget.postModel.user.id
                                        ? myProfileRoute
                                        : showUserRoute,
                                    arguments: {'user': widget.postModel.user});
                              },
                              child: Badge(
                                badgeContent: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 10,
                                ),
                                showBadge: widget.postModel.user.badgeStatus == 2,
                                position: BadgePosition.bottomEnd(bottom: 0, end: -5),
                                badgeColor: kPrimaryColorLight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child: FadeInImage(
                                    placeholder: const AssetImage(userAvatar),
                                    image: NetworkImage(widget.postModel.user.image),
                                    fit: BoxFit.cover,
                                    imageErrorBuilder: (context, object, trace) {
                                      return Image.asset(
                                        appLogo,
                                        height: 45,
                                        width: 45,
                                      );
                                    },
                                    height: 45,
                                    width: 45,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                  },
                                  child: Text(
                                    widget.postModel.user.name,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: kPrimaryTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.postModel.timeStamp,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: kSecondaryTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        myUser.id == widget.postModel.user.id
                            ? Container()
                            : PopupMenuButton(
                          icon: const Icon(
                            FontAwesomeIcons.ellipsisV,
                            size: 16,
                            color: Colors.blue,
                          ),
                          onSelected: (newValue) {
                            // add this property
                            setState(() {
                              result1 =
                                  newValue;
                              if (result1 == 0) {
                                whoblocked = myUser.id;
                                whomblocked = widget.postModel.user.id;
                                if (validData(context)) {
                                  updatePost();
                                };
                              }
                              if (result1 == 1) {
                                Navigator.pushNamed(context, reportUserRoute,
                                    arguments: {
                                      'postid': widget.postModel.id,
                                      'userid': myUser.id,
                                    });
                              }
                              // it gives the value which is selected
                            });
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                            const PopupMenuItem(
                              value: 0,
                              child: Text('Block User'),
                            ),
                            const PopupMenuItem(
                              value: 1,
                              child: Text('Report Post'),
                            ),
                          ],
                        ),
                        // GestureDetector(
                        //   onTap: (){
                        //   },
                        //   child: const Icon(
                        //     FontAwesomeIcons.ellipsisV,
                        //     size: 16,
                        //     color: Colors.blue,
                        //   ),
                        // ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            child: Text(
                              widget.postModel.heading.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: kPrimaryTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // getSinglePostFunc(widget.postModel.id);
                        // Navigator.pushReplacementNamed(context, urlRoute,
                        // arguments: {'postID': widget.postModel.id}
                        // );
                      },
                      child: AbsorbPointer(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                          ),
                          child: quil.QuillEditor.basic(
                            controller: _summaryController,
                            readOnly: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: MaterialButton(
                              onPressed: () {
                                _launchURL(widget.postModel.articleLink.toString());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Icon(
                                    Icons.article,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  Text(
                                    'Article',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                              color: kSecondaryColorDark,
                            ),
                          ),
                        ),
                        widget.postModel.videoLink.isNotEmpty
                            ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: MaterialButton(
                              onPressed: () {
                                _launchURL1(widget.postModel.videoLink, context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  Text(
                                    'Watch',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              color: kSecondaryColorDark,
                            ),
                          ),
                        )
                            : Container(),
                        Expanded(
                          child: widget.postModel.pdf.isNotEmpty
                              ? Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: MaterialButton(
                              onPressed: () {
                                _launchURL(widget.postModel.pdf);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Icon(
                                    Icons.article,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  Text(
                                    'PDF',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              color: kSecondaryColorDark,
                            ),
                          )
                              : Container(),
                        ),
                        if (widget.postModel.videoLink.isEmpty) Expanded(child: Container())
                      ],
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (widget.postModel.userLike) {
                                widget.postModel.likes--;
                                widget.postModel.userLike = false;
                                NetworkHelper().unlikePost(widget.postModel.id.toString());
                                setState(() {
                                  // State Changes when Like
                                });
                              } else {
                                widget.postModel.likes++;
                                widget.postModel.userLike = true;
                                NetworkHelper().likePost(widget.postModel.id.toString());
                                setState(() {
                                });
                                if (widget.postModel.userDislike) {
                                  widget.postModel.userDislike = false;
                                  widget.postModel.dislikes--;
                                  setState(() {
                                    // State Changes when Like
                                  });
                                }
                              }
                              final _postsData = Provider.of<HomePostsProvider>(context,
                                  listen: false);
                              _postsData.updateChanges();
                            },
                            child: Icon(
                              Icons.favorite,
                              color: widget.postModel.userLike
                                  ? Colors.red
                                  : kSecondaryTextColor,
                              size: 22,
                            ),
                          ),
                          SizedBox(
                            width: widget.isMyPost ? 5 : 10,
                          ),
                          Text(
                            widget.postModel.likes.toString(),
                            style: const TextStyle(color: kSecondaryTextColor),
                          ),
                          widget.isMyPost ?
                          const SizedBox(
                            width: 10,
                          ):
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (widget.postModel.userDislike) {
                                widget.postModel.dislikes--;
                                widget.postModel.userDislike = false;
                                NetworkHelper()
                                    .unDislikePost(widget.postModel.id.toString());
                              setState(() {
                                // State Changes when Unlike
                              });
                              } else {
                                widget.postModel.dislikes++;
                                widget.postModel.userDislike = true;
                                NetworkHelper().dislikePost(widget.postModel.id.toString());
                                if (widget.postModel.userLike) {
                                  widget.postModel.userLike = false;
                                  widget.postModel.likes--;
                                }
                                setState(() {
                                  // State Changes when Unlike
                                });
                              }
                              final _postsData = Provider.of<HomePostsProvider>(context,
                                  listen: false);
                              _postsData.updateChanges();

                            },
                            child: Icon(
                              Icons.thumb_down,
                              color: widget.postModel.userDislike
                                  ? Colors.red
                                  : kSecondaryTextColor,
                              size: 22,
                            ),
                          ),
                          SizedBox(
                            width: widget.isMyPost ? 5 : 10,
                          ),
                          Text(
                            widget.postModel.dislikes.toString(),
                            style: const TextStyle(
                              color: kSecondaryTextColor,
                            ),
                          ),
                          widget.isMyPost ?
                          const SizedBox(
                            width: 10,
                          ):
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.pushNamed(context, commentsRoute,
                                  arguments: {'post': widget.postModel});
                              final _postsData = Provider.of<HomePostsProvider>(context,
                                  listen: false);
                              _postsData.updateChanges();
                              setState(() {
                                // State Changes when commented
                              });
                            },
                            child: const Icon(
                              Icons.chat_bubble_outline,
                              color: kSecondaryTextColor,
                              size: 22,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.pushNamed(context, commentsRoute,
                                  arguments: {'post': widget.postModel});
                              final _postsData = Provider.of<HomePostsProvider>(context,
                                  listen: false);
                              _postsData.updateChanges();
                            },
                            child: SizedBox(
                              width: widget.isMyPost ? 5 : 10,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.pushNamed(context, commentsRoute,
                                  arguments: {'post': widget.postModel});
                              final _postsData = Provider.of<HomePostsProvider>(context,
                                  listen: false);
                              _postsData.updateChanges();
                            },
                            child: Text(
                              widget.postModel.commentsCount.toString(),
                              style: const TextStyle(
                                color: kSecondaryTextColor,
                              ),
                            ),
                          ),
                          if (widget.isMyPost)
                            const SizedBox(
                              width: 10,
                            ),
                          if (widget.isMyPost)
                            GestureDetector(
                              onTap: () async {
                                widget.deletePost!();
                              },
                              child: const Icon(
                                Icons.delete_outline,
                                color: kSecondaryTextColor,
                                size: 22,
                              ),
                            ),
                          if (widget.isMyPost)
                            const SizedBox(
                              width: 5,
                            ),
                          if (widget.isMyPost)
                            GestureDetector(
                              onTap: () async {
                                widget.deletePost!();
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  color: kSecondaryTextColor,
                                ),
                              ),
                            ),
                          widget.isMyPost ?
                          const SizedBox(
                            width: 15,
                          ):
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              // Share.share(quil.Document.fromJson(myJSON).toPlainText());
                            },
                            child: const Icon(
                              Icons.share,
                              color: kSecondaryTextColor,
                              size: 22,
                            ),
                          ),
                          widget.isMyPost ?
                          const SizedBox(
                            width: 15,
                          ):
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                                var myJSON = jsonDecode(widget.postModel.summary.toString());
                                quil.Document doc =
                                quil.Document.fromJson(myJSON);
                                speak(doc.toPlainText());
                            },
                            child: const Icon(
                              Icons.volume_up,
                              color: kSecondaryTextColor,
                              size: 22,
                            ),
                          ),
                          myUser.id == widget.postModel.user.id
                              ?
                          const SizedBox(
                            width: 15,
                          ):
                          Container(),
                          myUser.id == widget.postModel.user.id
                              ? GestureDetector(
                            onTap: () async {
                              Navigator.pushNamed(context, editPostRoute,
                                  arguments: EditPostArgument(
                                    userId: userId,
                                    postId: postId,
                                    heading: heading,
                                    summary: summary,
                                    videolink: videolink,
                                    ariclelink: ariclelink,
                                    // category: category,
                                  ));
                            },
                            child: const Icon(
                              Icons.edit,
                              color: kSecondaryTextColor,
                              size: 19,
                            ),
                          )
                              : Container(),
                          const SizedBox(width: 15,),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              FontAwesomeIcons.magnifyingGlassMinus,
                              color: kSecondaryTextColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
              )
            ),
          ),
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
  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
    print("abcd");
  }

  void _launchURL1(String url, BuildContext context) async {
    Navigator.pushNamed(context, ytScreen, arguments: RouteArgument(url: url));
  }

  void updatePost() async {
    setState(() {
      _loading = true;
    });
    try{
      Map results = await NetworkHelper().blockUser(
        whoblocked,
        whomblocked,
      );
      if (!results['error']) {
        SnackBarHelper.showSnackBarWithoutAction(context, message: 'User Blocked');
        // Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, homeRoute, (route) => false);
      } else {
        SnackBarHelper.showSnackBarWithoutAction(context,
            message: results['errorData']);
      }

    } catch(e) {
      SnackBarHelper.showSnackBarWithoutAction(context, message: e.toString());

    }
    setState(() {
      _loading = false;
    });
  }
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

bool validData(context) {
  if (whoblocked=='') {
    SnackBarHelper.showSnackBarWithoutAction(context,
        message: 'Try Again');
    return false;
  }
  if (whomblocked=='') {
    SnackBarHelper.showSnackBarWithoutAction(context,
        message: 'Try Again');
    return false;
  }
  return true;
}