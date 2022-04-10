import 'package:badges/badges.dart';
import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/post_model.dart';
import 'package:briefify/models/route_argument.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/screens/PostDetail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'dart:convert';
import 'package:briefify/models/edit_post_argument.dart';
import 'package:briefify/providers/home_posts_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlPage extends StatefulWidget {
  var postID;
  final VoidCallback? deletePost;
  final bool isMyPost;
   UrlPage({
    Key? key,
    required this.postID,
    this.deletePost,
     this.isMyPost = false,
  }) : super(key: key);

  @override
  State<UrlPage> createState() => _UrlPageState();
}
var result1;
late int whoblocked;
late int whomblocked;
bool playaudio = true;

/// Modal Initialize
var loading = true;
/// Modal Initialize

class _UrlPageState extends State<UrlPage> {
  @override
  void initState() {
    // Todo Extra
    getSinglePost();
    // Todo Extra
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserProvider>(context, listen: false);
    final myUser = _userData.user;
    final _postData = Provider.of<PostProvider>(context);
    PostModel postModel = _postData.post;
    final int userId = myUser.id as int;
    final int postId = postModel.id as int;
    final String heading = postModel.heading as String;
    final String summary = postModel.summary as String;
    final String videolink = postModel.videoLink as String;
    final String ariclelink = postModel.articleLink as String;

    var myJSON = jsonDecode(postModel.summary);
    final quil.QuillController _summaryController = quil.QuillController(
      document: quil.Document.fromJson(myJSON),
      selection: const TextSelection.collapsed(offset: 0),
    );
    return Scaffold(
      body:
      loading == true
          ? const Center(child: CircularProgressIndicator()) :
      Stack(
        children: [
          SafeArea(
            child: WillPopScope(
              onWillPop: () async {
                Navigator.pushNamedAndRemoveUntil(
                    context, homeRoute, ModalRoute.withName(welcomeRoute));
                return true;
              },
              child: Container(
                  child: SingleChildScrollView(
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
                                            myUser.id == postModel.user.id
                                                ? myProfileRoute
                                                :
                                            // homeRoute);
                                            showUserRoute,
                                            arguments: {'user': postModel.user});
                                      },
                                      child: Badge(
                                        badgeContent: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                        showBadge: postModel.user.badgeStatus == 2,
                                        position: BadgePosition.bottomEnd(bottom: 0, end: -5),
                                        badgeColor: kPrimaryColorLight,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(200),
                                          child: FadeInImage(
                                            placeholder: const AssetImage(userAvatar),
                                            image: NetworkImage(postModel.user.image),
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
                                            postModel.user.name,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: kPrimaryTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          postModel.timeStamp.toString(),
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
                                myUser.id == postModel.user.id
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
                                        whomblocked = postModel.user.id;
                                        if (validData(context)) {
                                          updatePost();
                                        };
                                      }
                                      if (result1 == 1) {
                                        Navigator.pushNamed(context, reportUserRoute,
                                            arguments: {
                                              'postid': postModel.id,
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
                                      postModel.heading,
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
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                              ),
                              child: quil.QuillEditor.basic(
                                controller: _summaryController,
                                readOnly: true,
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
                                        _launchURL(postModel.articleLink);
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
                                postModel.videoLink.isNotEmpty
                                    ? Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: MaterialButton(
                                      onPressed: () {
                                        _launchURL1(postModel.videoLink, context);
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
                                  child: postModel.pdf != null
                                      ? Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: MaterialButton(
                                      onPressed: () {
                                        _launchURL(postModel.pdf.toString());
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
                                if (postModel.videoLink.isEmpty) Expanded(child: Container())
                              ],
                            ),
                            const SizedBox(height: 20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (postModel.userLike) {
                                        postModel.likes--;
                                        postModel.userLike = false;
                                        NetworkHelper().unlikePost(postModel.id.toString());
                                        setState(() {
                                          // State Changes when Like
                                        });
                                      } else {
                                        postModel.likes++;
                                        postModel.userLike = true;
                                        NetworkHelper().likePost(postModel.id.toString());
                                        setState(() {
                                        });
                                        if (postModel.userDislike) {
                                          postModel.userDislike = false;
                                          postModel.dislikes--;
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
                                      color: postModel.userLike
                                          ? Colors.red
                                          : kSecondaryTextColor,
                                      size: 22,
                                    ),
                                  ),
                                  SizedBox(
                                    width: widget.isMyPost ? 5 : 10,
                                  ),
                                  Text(
                                    postModel.likes.toString(),
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
                                      if (postModel.userDislike) {
                                        postModel.dislikes--;
                                        postModel.userDislike = false;
                                        NetworkHelper()
                                            .unDislikePost(postModel.id.toString());
                                        setState(() {
                                          // State Changes when Unlike
                                        });
                                      } else {
                                        postModel.dislikes++;
                                        postModel.userDislike = true;
                                        NetworkHelper().dislikePost(postModel.id.toString());
                                        if (postModel.userLike) {
                                          postModel.userLike = false;
                                          postModel.likes--;
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
                                      color: postModel.userDislike
                                          ? Colors.red
                                          : kSecondaryTextColor,
                                      size: 22,
                                    ),
                                  ),
                                  SizedBox(
                                    width: widget.isMyPost ? 5 : 10,
                                  ),
                                  Text(
                                    postModel.dislikes.toString(),
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
                                          arguments: {'post': postModel});
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
                                          arguments: {'post': postModel});
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
                                          arguments: {'post': postModel});
                                      final _postsData = Provider.of<HomePostsProvider>(context,
                                          listen: false);
                                      _postsData.updateChanges();
                                    },
                                    child: Text(
                                      postModel.commentsCount.toString(),
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
                                      var myJSON = jsonDecode(postModel.summary);
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
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  myUser.id == postModel.user.id
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
                    ),
                  )
              ),
            ),
          ),
          Positioned(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, homeRoute, ModalRoute.withName(welcomeRoute));
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
  void updatePost() async {
    setState(() {
      loading = true;
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
      loading = false;
    });
  }
  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
    print("abcd");
  }

  void _launchURL1(String url, BuildContext context) async {
    Navigator.pushNamed(context, ytScreen, arguments: RouteArgument(url: url));
  }
// Todo Extra
void getSinglePost() async {
  setState(() {
    loading = true;
  });

  try {
    var postId = widget.postID.toString();
    // Try
    final _postData = Provider.of<PostProvider>(context, listen: false);
    Map<String, String> getpost = {
      'post_id': postId,
    };
    Map results = await NetworkHelper().getSinglePost(getpost);
    if (!results['error']) {
      PostModel post = results['post'];
      _postData.post = post;
      SnackBarHelper.showSnackBarWithoutAction(context, message: 'Post Found');
    } else {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: results['errorData']);
    }
  } catch (e) {
    // Catch
    SnackBarHelper.showSnackBarWithoutAction(context, message: e.toString());
  }
  setState(() {
    loading = false;
  });
}
// Todo Extra
}