import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/snack_helper.dart';

class ArtCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback? deletePost;
  final bool isMyPost;
  const ArtCard({Key? key,
    required this.post,
    this.deletePost,
    this.isMyPost = false}) : super(key: key);

  @override
  State<ArtCard> createState() => _ArtCardState();
}

class _ArtCardState extends State<ArtCard> {
  var result1;
  late int whoblocked;
  late int whomblocked;
  bool _loading = false;
  bool isFlipped = false;

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
    final String videolink = widget.post.videoLink;
    final String ariclelink = widget.post.articleLink.toString();
    final String art = widget.post.art_image.toString();
    final String artimg = baseimgurl+art;
    bool val = false;

    final String heading = widget.post.heading.toString().isEmpty || widget.post.heading.toString()==null
    ?
    'Write Something...'
    :
    widget.post.heading.toString();
    final String summary = widget.post.summary.toString().isEmpty || widget.post.summary.toString() == null
    ?
    'This is post summary'
    :
    widget.post.summary.toString();
    final _summaryController = summary;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
      decoration: const BoxDecoration(
        color: Color(0xffEDF0F4),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xffFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 20),
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
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: const BoxDecoration(
                        color: Color(0xffEFF2F7),
                        borderRadius: BorderRadius.all(Radius.circular(200)),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.ellipsisH,
                        size: 16,
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () {
                      showModalBottomSheet<dynamic>(
                          context: context,
                          builder: (BuildContext bc){
                            return Wrap(
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 20, 0, 40),
                                  // color: Colors.transparent, //could change this to Color(0xFF737373),
                                  //so you don't have to change MaterialApp canvasColor
                                  child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      myUser.id != widget.post.user.id ?
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: GestureDetector(
                                              onTap: () {
                                                whoblocked = myUser.id;
                                                whomblocked = widget.post.user.id;
                                                if(validData()) {
                                                  updatePost();
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(5.0),
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xffEFF2F7),
                                                      borderRadius: BorderRadius.all(Radius.circular(200)),
                                                    ),
                                                    child: const Icon(Icons.block,
                                                      size: 30,
                                                      color: kSecondaryTextColor,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: const [
                                                      Text('Block User',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text("stop seeing this user's posts",
                                                        style: TextStyle(
                                                            fontSize: 12
                                                        ),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context, reportUserRoute,
                                                    arguments: {
                                                      'postid': widget.post.id,
                                                      'userid': myUser.id,
                                                    }
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(5.0),
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xffEFF2F7),
                                                      borderRadius: BorderRadius.all(Radius.circular(200)),
                                                    ),
                                                    child: const Icon(Icons.report,
                                                      size: 30,
                                                      color: kSecondaryTextColor,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: const [
                                                      Text('Report Post',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500,
                                                        ),),
                                                      Text("I'm concerned about this post",
                                                        style: TextStyle(
                                                            fontSize: 12
                                                        ),),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ):
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: GestureDetector(
                                          onTap: () async {
                                            Navigator.pushNamed(context, editArtRoute,
                                                arguments: EditPostArgument(
                                                  userId: userId,
                                                  postId: postId,
                                                  heading: heading,
                                                  artimg: artimg,
                                                ));
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(5.0),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xffEFF2F7),
                                                  borderRadius: BorderRadius.all(Radius.circular(200)),
                                                ),
                                                child: const Icon(Icons.edit,
                                                  size: 30,
                                                  color: kSecondaryTextColor,
                                                ),
                                              ),
                                              const SizedBox(width: 10,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: const [
                                                  Text('Edit Post',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text("make some changes to the post",
                                                    style: TextStyle(
                                                        fontSize: 12
                                                    ),),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                      );
                    },
                  ),
                  // PopupMenuButton(
                  //         icon: const Icon(
                  //           FontAwesomeIcons.ellipsisH,
                  //           size: 16,
                  //           color: Colors.blue,
                  //         ),
                  //         onSelected: (newValue) {
                  //           // add this property
                  //           setState(() {
                  //             result1 = newValue;
                  //             if (result1 == 0) {
                  //               whoblocked = myUser.id;
                  //               whomblocked = widget.post.user.id;
                  //               if (validData()) {
                  //                 updatePost();
                  //               }
                  //             }
                  //             if (result1 == 1) {
                  //               Navigator.pushNamed(context, reportUserRoute,
                  //                   arguments: {
                  //                     'postid': widget.post.id,
                  //                     'userid': myUser.id,
                  //                   });
                  //             }
                  //             // it gives the value which is selected
                  //           });
                  //         },
                  //         itemBuilder: (BuildContext context) =>
                  //             <PopupMenuEntry>[
                  //           const PopupMenuItem(
                  //             value: 0,
                  //             child: Text('Block User'),
                  //           ),
                  //           const PopupMenuItem(
                  //             value: 1,
                  //             child: Text('Report Post'),
                  //           ),
                  //         ],
                  //       ),
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
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, artdetailRoute,
                      arguments: {'postModel': widget.post});
                },
                onLongPress: () {
                  setState(() {
                    print('onLongPress');
                  });
                },
                onLongPressCancel: () {
                  print('onLongPressCancel');
                },
                child: AnimatedSwitcher(
                  reverseDuration: const Duration(seconds: 1),
                  duration: const Duration(seconds: 1),
                  transitionBuilder: (Widget child,
                      Animation<double> animation
                  ) => ScaleTransition(
                    child: child,
                    scale: animation,
                  ),
                  child: isFlipped == false
                  ?
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                      placeholder: const AssetImage(loadingart),
                      placeholderFit: BoxFit.fill,
                      image: NetworkImage(
                        artimg,
                      ),
                      fit: BoxFit.fill,
                      imageErrorBuilder: (context, object, trace) {
                        return Image.asset(
                          appLogo,
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                        );
                      },
                      height: 250,
                        width: MediaQuery.of(context).size.width,
                    ),
                  )
                  :
                  Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color(0XffEDF0F4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 250,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                          child: Text(
                            heading,
                            style: GoogleFonts.lobster(
                              fontSize: 18,
                              letterSpacing: 1,
                              wordSpacing: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// Like Button
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
                      final _postsData = Provider.of<ArtPostsProvider>(
                          context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: Icon(
                      widget.post.userLike ?
                      FontAwesomeIcons.solidHeart:
                      FontAwesomeIcons.heart,
                      color: widget.post.userLike
                          ? Colors.red
                          : kSecondaryTextColor,
                      size: 20,
                    ),
                  ),
                  /// Like Button
                  ///
                  /// space between like icon and number of likes
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
                      final _postsData = Provider.of<ArtPostsProvider>(
                          context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: const SizedBox(
                      width: 8,
                    ),
                  ),
                  /// space between like icon and number of likes
                  ///
                  /// Number of Likes
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
                      final _postsData = Provider.of<ArtPostsProvider>(
                          context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: Text(
                      widget.post.likes.toString(),
                      style: const TextStyle(color: kSecondaryTextColor),
                    ),
                  ),
                  /// Number of Likes
                  ///

                  ///
                  const SizedBox(
                    width: 20,
                  ),
                  /// Comment Icon
                  GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(context, commentsRoute,
                          arguments: {'post': widget.post});
                      final _postsData = Provider.of<ArtPostsProvider>(
                          context,
                          listen: false);
                      _postsData.updateChanges();
                      setState(() {
                        // State Changes when commented
                      });
                    },
                    child: const Icon(
                      FontAwesomeIcons.comment,
                      color: kSecondaryTextColor,
                      size: 20,
                    ),
                  ),
                  /// Comment Icon
                  ///
                  /// space between comment icon and number of comments
                  GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(context, commentsRoute,
                          arguments: {'post': widget.post});
                      final _postsData = Provider.of<ArtPostsProvider>(
                          context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: const SizedBox(
                      width: 8,
                    ),
                  ),
                  /// space between comment icon and number of comments
                  ///
                  /// Number of comments
                  GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(context, commentsRoute,
                          arguments: {'post': widget.post});
                      final _postsData = Provider.of<ArtPostsProvider>(
                          context,
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
                  /// Number of comments
                  ///
                  const SizedBox(
                    width: 20,
                  ),
                  /// share icon
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
                            title: 'Art Post',
                            imageUrl: widget.post.user.image,
                            // imageUrl:
                            //     'https://flutter.dev/assets/flutter-lockup-4cb0ee072ab312e59784d9fbf4fb7ad42688a7fdaea1270ccf6bbf4f34b7e03f.svg',
                            // contentDescription: 'Flutter Branch Description',
                            contentDescription:
                            'This is briefify Art post',
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
                      FontAwesomeIcons.share,
                      color: kSecondaryTextColor,
                      size: 20,
                    ),
                  ),
                  /// share icon
                  ///
                  const SizedBox(
                    width: 20,
                  ),
                  /// Dislike Button
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
                        NetworkHelper()
                            .dislikePost(widget.post.id.toString());
                        if (widget.post.userLike) {
                          widget.post.userLike = false;
                          widget.post.likes--;
                        }
                        setState(() {
                          // State Changes when Unlike
                        });
                      }
                      final _postsData = Provider.of<ArtPostsProvider>(
                          context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: Icon(
                      Icons.thumb_down,
                      color: widget.post.userDislike
                          ? Colors.red
                          : kSecondaryTextColor,
                      size: 20,
                    ),
                  ),
                  /// Dislike Button
                  ///
                  /// space bvetween dislike and number of dislike
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
                        NetworkHelper()
                            .dislikePost(widget.post.id.toString());
                        if (widget.post.userLike) {
                          widget.post.userLike = false;
                          widget.post.likes--;
                        }
                      }
                      final _postsData = Provider.of<ArtPostsProvider>(
                          context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: const SizedBox(
                      width: 8,
                    ),
                  ),
                  /// space bvetween dislike and number of dislike
                  ///
                  /// Number of Dislike
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
                        NetworkHelper()
                            .dislikePost(widget.post.id.toString());
                        if (widget.post.userLike) {
                          widget.post.userLike = false;
                          widget.post.likes--;
                        }
                      }
                      final _postsData = Provider.of<ArtPostsProvider>(
                          context,
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
                  /// Number of Dislike
                  const SizedBox(width: 20,),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFlipped = !isFlipped;
                      });
                    },
                    child: const Icon(
                      FontAwesomeIcons.flipboard,
                      color: kSecondaryTextColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
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
