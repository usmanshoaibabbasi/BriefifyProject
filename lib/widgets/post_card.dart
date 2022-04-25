import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/models/edit_post_argument.dart';
import 'package:briefify/models/post_model.dart';
import 'package:briefify/models/route_argument.dart';
import 'package:briefify/providers/home_posts_provider.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/snack_helper.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback? deletePost;
  final VoidCallback playAudio;
  final bool isMyPost;

  const PostCard(
      {Key? key,
      required this.post,
      required this.playAudio,
      this.deletePost,
      this.isMyPost = false})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  var result1;
  late int whoblocked;
  late int whomblocked;
  bool _loading = false;

  StreamController<String> controllerUrl = StreamController<String>();

  void generateLink(BranchUniversalObject buo, BranchLinkProperties lp) async {
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
    if (response.success) {
      print(response.result);
      Share.share(response.result);
      controllerUrl.sink.add('${response.result}');
    } else {
      controllerUrl.sink
          .add('Error : ${response.errorCode} - ${response.errorMessage}');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserProvider>(context, listen: false);
    final myUser = _userData.user;
    final int userId = myUser.id;
    final int postId = widget.post.id;
    final String heading = widget.post.heading;
    final String summary = widget.post.summary;
    final String videolink = widget.post.videoLink;
    final String ariclelink = widget.post.articleLink;
    var category = widget.post.category;

    var myJSON = jsonDecode(widget.post.summary);
    final quil.QuillController _summaryController = quil.QuillController(
      document: quil.Document.fromJson(myJSON),
      selection: const TextSelection.collapsed(offset: 0),
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 10, 15),
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
                        // final _userData = Provider.of<UserProvider>(context, listen: false);
                        // final myUser = _userData.user;
                        // Navigator.pushNamed(context, myUser.id == post.user.id ? myProfileRoute : showUserRoute,
                        //     arguments: {'user': post.user});
                        Navigator.pushNamed(
                            context,
                            myUser.id == widget.post.user.id
                                ? myProfileRoute
                                : showUserRoute,
                            arguments: {'user': widget.post.user});
                      },
                      child: Badge(
                        badgeContent: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 10,
                        ),
                        showBadge: widget.post.user.badgeStatus == 2,
                        position: BadgePosition.bottomEnd(bottom: 0, end: -5),
                        badgeColor: kPrimaryColorLight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: FadeInImage(
                            placeholder: const AssetImage(userAvatar),
                            image: NetworkImage(widget.post.user.image),
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
                            // Navigator.pushNamed(
                            //     context,
                            //     myUser.id == widget.post.user.id
                            //         ? myProfileRoute
                            //         : showUserRoute,
                            //     arguments: {'user': widget.post.user});
                          },
                          child: Text(
                            widget.post.user.name,
                            maxLines: 1,
                            style: const TextStyle(
                              color: kPrimaryTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          widget.post.timeStamp,
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
                myUser.id == widget.post.user.id
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
                            result1 = newValue;
                            if (result1 == 0) {
                              whoblocked = myUser.id;
                              whomblocked = widget.post.user.id;
                              if (validData()) {
                                updatePost();
                              }
                            }
                            if (result1 == 1) {
                              Navigator.pushNamed(context, reportUserRoute,
                                  arguments: {
                                    'postid': widget.post.id,
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
                      widget.post.heading,
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
                Navigator.pushNamed(context, postdetailRoute,
                    arguments: {'postModel': widget.post});
              },
              child: AbsorbPointer(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
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
                        _launchURL(widget.post.articleLink);
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
                widget.post.videoLink.isNotEmpty
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: MaterialButton(
                            onPressed: () {
                              _launchURL1(widget.post.videoLink, context);
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
                  child: widget.post.pdf.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: MaterialButton(
                            onPressed: () {
                              _launchURL(widget.post.pdf);
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
                if (widget.post.videoLink.isEmpty) Expanded(child: Container())
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.post.userLike) {
                        widget.post.likes--;
                        widget.post.userLike = false;
                        NetworkHelper().unlikePost(widget.post.id.toString());
                        setState(() {
                          // State Changes when Like
                        });
                      } else {
                        widget.post.likes++;
                        widget.post.userLike = true;
                        NetworkHelper().likePost(widget.post.id.toString());
                        if (widget.post.userDislike) {
                          widget.post.userDislike = false;
                          widget.post.dislikes--;
                        }
                        setState(() {
                          // State Changes when DisLike
                        });
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: Icon(
                      Icons.favorite,
                      color: widget.post.userLike
                          ? Colors.red
                          : kSecondaryTextColor,
                      size: 22,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.post.userLike) {
                        widget.post.likes--;
                        widget.post.userLike = false;
                        NetworkHelper().unlikePost(widget.post.id.toString());
                      } else {
                        widget.post.likes++;
                        widget.post.userLike = true;
                        NetworkHelper().likePost(widget.post.id.toString());
                        if (widget.post.userDislike) {
                          widget.post.userDislike = false;
                          widget.post.dislikes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: const SizedBox(
                      width: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.post.userLike) {
                        widget.post.likes--;
                        widget.post.userLike = false;
                        NetworkHelper().unlikePost(widget.post.id.toString());
                      } else {
                        widget.post.likes++;
                        widget.post.userLike = true;
                        NetworkHelper().likePost(widget.post.id.toString());
                        if (widget.post.userDislike) {
                          widget.post.userDislike = false;
                          widget.post.dislikes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: Text(
                      widget.post.likes.toString(),
                      style: const TextStyle(color: kSecondaryTextColor),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (widget.post.userDislike) {
                        widget.post.dislikes--;
                        widget.post.userDislike = false;
                        NetworkHelper()
                            .unDislikePost(widget.post.id.toString());
                        setState(() {
                          // State Changes when Unlike
                        });
                      } else {
                        widget.post.dislikes++;
                        widget.post.userDislike = true;
                        NetworkHelper().dislikePost(widget.post.id.toString());
                        if (widget.post.userLike) {
                          widget.post.userLike = false;
                          widget.post.likes--;
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
                      color: widget.post.userDislike
                          ? Colors.red
                          : kSecondaryTextColor,
                      size: 22,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (widget.post.userDislike) {
                        widget.post.dislikes--;
                        widget.post.userDislike = false;
                        NetworkHelper()
                            .unDislikePost(widget.post.id.toString());
                      } else {
                        widget.post.dislikes++;
                        widget.post.userDislike = true;
                        NetworkHelper().dislikePost(widget.post.id.toString());
                        if (widget.post.userLike) {
                          widget.post.userLike = false;
                          widget.post.likes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: const SizedBox(
                      width: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (widget.post.userDislike) {
                        widget.post.dislikes--;
                        widget.post.userDislike = false;
                        NetworkHelper()
                            .unDislikePost(widget.post.id.toString());
                      } else {
                        widget.post.dislikes++;
                        widget.post.userDislike = true;
                        NetworkHelper().dislikePost(widget.post.id.toString());
                        if (widget.post.userLike) {
                          widget.post.userLike = false;
                          widget.post.likes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: Text(
                      widget.post.dislikes.toString(),
                      style: const TextStyle(
                        color: kSecondaryTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(context, commentsRoute,
                          arguments: {'post': widget.post});
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
                          arguments: {'post': widget.post});
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: const SizedBox(
                      width: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(context, commentsRoute,
                          arguments: {'post': widget.post});
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: Text(
                      widget.post.commentsCount.toString(),
                      style: const TextStyle(
                        color: kSecondaryTextColor,
                      ),
                    ),
                  ),
                  // if (widget.isMyPost)
                  //   GestureDetector(
                  //     onTap: () async {
                  //       widget.deletePost!();
                  //     },
                  //     child: const Icon(
                  //       Icons.delete_outline,
                  //       color: kSecondaryTextColor,
                  //       size: 22,
                  //     ),
                  //   ),
                  // if (widget.isMyPost)
                  //   const SizedBox(
                  //     width: 5,
                  //   ),
                  // if (widget.isMyPost)
                  //   GestureDetector(
                  //     onTap: () async {
                  //       widget.deletePost!();
                  //     },
                  //     child: const Text(
                  //       'Delete',
                  //       style: TextStyle(
                  //         color: kSecondaryTextColor,
                  //       ),
                  //     ),
                  //   ),
                  // widget.isMyPost
                  //     ? const SizedBox(
                  //         width: 15,
                  //       )
                  //     :
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      print('click on share');
                      BranchLinkProperties lp = BranchLinkProperties(
                          channel: 'facebook',
                          feature: 'sharing',
                          //parameter alias
                          //Instead of our standard encoded short url, you can specify the vanity alias.
                          // For example, instead of a random string of characters/integers, you can set the vanity alias as *.app.link/devonaustin.
                          // Aliases are enforced to be unique** and immutable per domain, and per link - they cannot be reused unless deleted.
                          //alias: 'https://branch.io' //define link url,
                          stage: 'new share',
                          campaign: 'xxxxx',
                          tags: ['one', 'two', 'three']);
                      lp.addControlParam('\$uri_redirect_mode', '1');
                      return generateLink(
                        BranchUniversalObject(
                            // canonicalIdentifier: 'flutter/branch',
                            canonicalIdentifier: 'Briefifiy.io',
                            // parameter canonicalUrl
                            // title: 'Flutter Branch Plugin',
                            title: widget.post.heading.toString(),
                            imageUrl: widget.post.user.image,
                            // imageUrl:
                            //     'https://flutter.dev/assets/flutter-lockup-4cb0ee072ab312e59784d9fbf4fb7ad42688a7fdaea1270ccf6bbf4f34b7e03f.svg',
                            // contentDescription: 'Flutter Branch Description',
                            contentDescription:
                                widget.post.summary.substring(12, 40),
                            contentMetadata: BranchContentMetaData()
                              // ..addCustomMetadata('title', widget.post.heading)
                              ..addCustomMetadata('postId', widget.post.id),
                            // ..addCustomMetadata(
                            //     'imageUrl', widget.post.user.image),
                            // ..addCustomMetadata(
                            //     'category', widget.post.user.email)
                            // ..addCustomMetadata('key', 1)
                            // ..addCustomMetadata('custom_bool', true)
                            // ..addCustomMetadata(
                            //     'custom_list_number', [1, 2, 3, 4, 5])
                            // ..addCustomMetadata(
                            //     'custom_list_string', ['a', 'b', 'c']),

                            // contentMetadata: metadata,
                            keywords: ['Plugin', 'Branch', 'Flutter'],
                            publiclyIndex: true,
                            locallyIndex: true,
                            expirationDateInMilliSec: DateTime.now()
                                .add(const Duration(days: 365))
                                .millisecondsSinceEpoch),
                        lp,
                        // Share.share(quil.Document.fromJson(myJSON).toPlainText());
                      );
                    },
                    child: const Icon(
                      Icons.share,
                      color: kSecondaryTextColor,
                      size: 22,
                    ),
                  ),
                  widget.isMyPost
                      ? const SizedBox(
                          width: 15,
                        )
                      : const SizedBox(
                          width: 20,
                        ),
                  GestureDetector(
                    onTap: () async {
                      widget.playAudio();
                    },
                    child: const Icon(
                      Icons.volume_up,
                      color: kSecondaryTextColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  myUser.id == widget.post.user.id
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Block Validation
  bool validData() {
    if (whoblocked == '') {
      SnackBarHelper.showSnackBarWithoutAction(context, message: 'Try Again');
      return false;
    }
    if (whomblocked == '') {
      SnackBarHelper.showSnackBarWithoutAction(context, message: 'Try Again');
      return false;
    }
    return true;
  }

  // Send Data To DataBase For Blocking User
  void updatePost() async {
    setState(() {
      _loading = true;
    });
    try {
      Map results = await NetworkHelper().blockUser(
        whoblocked,
        whomblocked,
      );
      if (!results['error']) {
        SnackBarHelper.showSnackBarWithoutAction(context,
            message: 'User Blocked');
        // Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, homeRoute, (route) => false);
      } else {
        SnackBarHelper.showSnackBarWithoutAction(context,
            message: results['errorData']);
      }
    } catch (e) {
      SnackBarHelper.showSnackBarWithoutAction(context, message: e.toString());
    }
    setState(() {
      _loading = false;
    });
  }

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
    print("abcd");
  }

  void _launchURL1(String url, BuildContext context) async {
    Navigator.pushNamed(context, ytScreen, arguments: RouteArgument(url: url));
  }
}
