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
    final String heading = widget.post.heading.toString();
    final String summary = widget.post.summary.toString();
    final String videolink = widget.post.videoLink;
    final String ariclelink = widget.post.articleLink.toString();
    var category = widget.post.category;

    var myJSON = jsonDecode(widget.post.summary.toString());
    final quil.QuillController _summaryController = quil.QuillController(
      document: quil.Document.fromJson(myJSON),
      selection: const TextSelection.collapsed(offset: 0),
    );
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
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext bc){
                                return Wrap(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(10, 30, 0, 40),
                                      // color: Colors.transparent, //could change this to Color(0xFF737373),
                                      //so you don't have to change MaterialApp canvasColor
                                      child: Column(
                                            children: [
                                              /// Article
                                              GestureDetector(
                                                onTap: () {
                                                  _launchURL(widget.post.articleLink.toString());
                                                },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(5.0),
                                                      decoration: const BoxDecoration(
                                                        color: Color(0xffEFF2F7),
                                                        borderRadius: BorderRadius.all(Radius.circular(200)),
                                                      ),
                                                      child: const Icon(Icons.article,
                                                        size: 30,
                                                        color: kSecondaryTextColor,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: const [
                                                        Text('View Article',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text("read the attached article",
                                                          style: TextStyle(
                                                              fontSize: 12
                                                          ),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              widget.post.videoLink.isNotEmpty
                                                  ?
                                              /// Video
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _launchURL1(widget.post.videoLink,context);
                                                    },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.all(5.0),
                                                        decoration: const BoxDecoration(
                                                          color: Color(0xffEFF2F7),
                                                          borderRadius: BorderRadius.all(Radius.circular(200)),
                                                        ),
                                                        child: const Icon(Icons.play_arrow,
                                                          size: 30,
                                                          color: kSecondaryTextColor,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10,),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: const [
                                                          Text('Watch Video',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                          Text("watch the attached youtube video",
                                                            style: TextStyle(
                                                                fontSize: 12
                                                            ),),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ):
                                              Container(),
                                              widget.post.pdf.isNotEmpty
                                                  ?
                                              /// Pdf
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _launchURL(widget.post.pdf);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.all(5.0),
                                                        decoration: const BoxDecoration(
                                                          color: Color(0xffEFF2F7),
                                                          borderRadius: BorderRadius.all(Radius.circular(200)),
                                                        ),
                                                        child: const Icon(Icons.picture_as_pdf,
                                                          size: 30,
                                                          color: kSecondaryTextColor,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10,),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: const [
                                                          Text('Read Pdf',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                          Text("read the attached doc",
                                                            style: TextStyle(
                                                                fontSize: 12
                                                            ),),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ):
                                              Container(),
                                              /// Block
                                              myUser.id == widget.post.user.id ?
                                              Container():
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
                                              /// Report
                                              myUser.id == widget.post.user.id ?
                                              Container():
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
                                              myUser.id == widget.post.user.id ?
                                              /// Edit Post
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20),
                                                child: GestureDetector(
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
                                              ):
                                              Container(),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Text(
                        widget.post.heading.toString(),
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
              const SizedBox(height: 5),
              /// Old Article and watch and pdf
              // Row(
              //   children: [
              //     Expanded(
              //       child: Padding(
              //         padding: const EdgeInsets.only(right: 10),
              //         child: MaterialButton(
              //           onPressed: () {
              //             _launchURL(widget.post.articleLink);
              //           },
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //             children: const [
              //               Icon(
              //                 Icons.article,
              //                 color: Colors.white,
              //                 size: 16,
              //               ),
              //               Text(
              //                 'Article',
              //                 style:
              //                     TextStyle(color: Colors.white, fontSize: 12),
              //               ),
              //             ],
              //           ),
              //           color: kSecondaryColorDark,
              //         ),
              //       ),
              //     ),
              //     widget.post.videoLink.isNotEmpty
              //         ? Expanded(
              //             child: Padding(
              //               padding: const EdgeInsets.only(right: 10),
              //               child: MaterialButton(
              //                 onPressed: () {
              //                   _launchURL1(widget.post.videoLink, context);
              //                 },
              //                 child: Row(
              //                   mainAxisAlignment:
              //                       MainAxisAlignment.spaceEvenly,
              //                   children: const [
              //                     Icon(
              //                       Icons.play_arrow,
              //                       color: Colors.white,
              //                       size: 16,
              //                     ),
              //                     Text(
              //                       'Watch',
              //                       style: TextStyle(
              //                         color: Colors.white,
              //                         fontSize: 12,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //                 color: kSecondaryColorDark,
              //               ),
              //             ),
              //           )
              //         : Container(),
              //     Expanded(
              //       child: widget.post.pdf.isNotEmpty
              //           ? Padding(
              //               padding: const EdgeInsets.only(right: 10),
              //               child: MaterialButton(
              //                 onPressed: () {
              //                   _launchURL(widget.post.pdf);
              //                 },
              //                 child: Row(
              //                   mainAxisAlignment:
              //                       MainAxisAlignment.spaceEvenly,
              //                   children: const [
              //                     Icon(
              //                       Icons.article,
              //                       color: Colors.white,
              //                       size: 16,
              //                     ),
              //                     Text(
              //                       'PDF',
              //                       style: TextStyle(
              //                         color: Colors.white,
              //                         fontSize: 12,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //                 color: kSecondaryColorDark,
              //               ),
              //             )
              //           : Container(),
              //     ),
              //     if (widget.post.videoLink.isEmpty)
              //       Expanded(child: Container())
              //   ],
              // ),
              /// Article and watch and pdf
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Container(
              //       padding: const EdgeInsets.all(5),
              //       decoration: const BoxDecoration(
              //         color: Color(0xffEFF2F7),
              //         borderRadius: BorderRadius.all(Radius.circular(200)),
              //       ),
              //       child: GestureDetector(
              //         onTap: () {
              //           _launchURL(widget.post.articleLink);
              //         },
              //         child: const Icon(
              //           FontAwesomeIcons.pager,
              //           color: kSecondaryTextColor,
              //           size: 22,
              //         ),
              //       ),
              //     ),
              //     widget.post.videoLink.isNotEmpty
              //         ?
              //     Padding(
              //       padding: const EdgeInsets.only(left: 5),
              //       child: Container(
              //         padding: const EdgeInsets.all(5),
              //         decoration: const BoxDecoration(
              //           color: Color(0xffEFF2F7),
              //           borderRadius: BorderRadius.all(Radius.circular(200)),
              //         ),
              //         child: GestureDetector(
              //           onTap: () {
              //             _launchURL1(widget.post.videoLink, context);
              //           },
              //           child: const Icon(
              //             Icons.play_arrow,
              //             color: kSecondaryTextColor,
              //             size: 22,
              //           ),
              //         ),
              //       ),
              //     ): Container(),
              //     widget.post.pdf.isNotEmpty
              //         ?
              //     Padding(
              //       padding: const EdgeInsets.only(left: 5,),
              //       child: Container(
              //         padding: const EdgeInsets.all(5),
              //         decoration: const BoxDecoration(
              //           color: Color(0xffEFF2F7),
              //           borderRadius: BorderRadius.all(Radius.circular(200)),
              //         ),
              //         child: GestureDetector(
              //           onTap: () {
              //             _launchURL(widget.post.pdf);
              //           },
              //           child: const Icon(
              //             Icons.picture_as_pdf,
              //             color: kSecondaryTextColor,
              //             size: 22,
              //           ),
              //         ),
              //       ),
              //     ): Container(),
              //   ],
              // ),
              const SizedBox(height: 15,),
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
                      final _postsData = Provider.of<HomePostsProvider>(
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
                      final _postsData = Provider.of<HomePostsProvider>(
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
                      final _postsData = Provider.of<HomePostsProvider>(
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
                      final _postsData = Provider.of<HomePostsProvider>(
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
                      final _postsData = Provider.of<HomePostsProvider>(
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
                      final _postsData = Provider.of<HomePostsProvider>(
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
                            // title: widget.post.heading.toString(),
                            title: 'Briefify post',
                            imageUrl: widget.post.user.image,
                            // imageUrl:
                            //     'https://flutter.dev/assets/flutter-lockup-4cb0ee072ab312e59784d9fbf4fb7ad42688a7fdaea1270ccf6bbf4f34b7e03f.svg',
                            // contentDescription: 'Flutter Branch Description',
                            contentDescription: 'This is briefify post',
                            // contentDescription: widget.post.summary.toString().length >40
                            // ?
                            // widget.post.summary.toString()
                            // :
                            // widget.post.summary.toString().substring(12, 40),
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
                      final _postsData = Provider.of<HomePostsProvider>(
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
                      final _postsData = Provider.of<HomePostsProvider>(
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
                      final _postsData = Provider.of<HomePostsProvider>(
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
                  const SizedBox(
                    width: 20,
                  ),
                  /// play audio icon
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
                  /// play audio icon
                  // const SizedBox(
                  //   width: 15,
                  // ),
                  // myUser.id == widget.post.user.id
                  //     ? GestureDetector(
                  //         onTap: () async {
                  //           Navigator.pushNamed(context, editPostRoute,
                  //               arguments: EditPostArgument(
                  //                 userId: userId,
                  //                 post Id: postId,
                  //                 heading: heading,
                  //                 summary: summary,
                  //                 videolink: videolink,
                  //                 ariclelink: ariclelink,
                  //                 // category: category,
                  //               ));
                  //         },
                  //         child: const Icon(
                  //           Icons.edit,
                  //           color: kSecondaryTextColor,
                  //           size: 19,
                  //         ),
                  //       )
                  //     : Container(),
                ],
              ),
            ],
          ),
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
