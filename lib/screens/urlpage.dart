import 'package:badges/badges.dart';
import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/urls.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/get_singlepost_modal.dart';
import 'package:briefify/models/post_model.dart';
import 'package:briefify/models/route_argument.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/screens/PostDetail.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'dart:convert';
import 'package:briefify/models/edit_post_argument.dart';
import 'package:briefify/providers/home_posts_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlPage extends StatefulWidget {
  var postID;
  // final PostModel postModel;
  final VoidCallback? deletePost;
  // final dynamic price;
  // final dynamic image;
  final bool isMyPost;
   UrlPage({
    Key? key,
    required this.postID,
    // required this.postModel,
    this.deletePost,
     this.isMyPost = false,
  }) : super(key: key);

  @override
  State<UrlPage> createState() => _UrlPageState();
}
var result1;
late int whoblocked;
late int whomblocked;
bool _loading = false;
bool playaudio = true;

/// Modal Initialize
late getSinglePostModal postModel;
late UserModel user;
var loading = true;
/// Modal Initialize

class _UrlPageState extends State<UrlPage> {
  @override
  void initState() {
    var postID = widget.postID.toString();
    setState(() {
      loading = true;
    });
    getSinglePostFunc(postID).then((value) => {
      setState(() {
    loading = false;
    })
    });
    // Todo Extra
    // getSinglePost();
    // Todo Extra
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserProvider>(context, listen: false);
    final myUser = _userData.user;
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
    // final _postData = Provider.of<PostProvider>(context, listen: false);
    // PostModel _post = _postData.post;
    return Scaffold(
      body: loading == true
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
                                            myUser.id == user.id
                                                ? myProfileRoute
                                                : homeRoute);
                                            // showUserRoute,
                                            // arguments: {'user': user});
                                      },
                                      child: Badge(
                                        badgeContent: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                        showBadge: user.badgeStatus == 2,
                                        position: BadgePosition.bottomEnd(bottom: 0, end: -5),
                                        badgeColor: kPrimaryColorLight,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(200),
                                          child: FadeInImage(
                                            placeholder: const AssetImage(userAvatar),
                                            image: NetworkImage(user.image),
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
                                            user.name,
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
                                myUser.id == user.id
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
                                        whomblocked = user.id;
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
                                  myUser.id == user.id
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
  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
    print("abcd");
  }

  void _launchURL1(String url, BuildContext context) async {
    Navigator.pushNamed(context, ytScreen, arguments: RouteArgument(url: url));
  }

Future<dynamic> getSinglePostFunc(String postID) async {
  final String apiToken = await Prefs().getApiToken();
  print(postID);
  var formData = FormData.fromMap({
    'post_id': postID,
  });
  Response response;
  Dio dio = Dio();
  try{
    //Try
    response = await dio.post(
        ugetSinglePost,
      options: Options(headers: {"Authorization": "Bearer $apiToken"}),
      data: formData,
    );
    if(response.statusCode == 200) {
      if (response.data.toString() == '') {
        print('No Data Found');
      }
      var resp = jsonDecode(jsonEncode(response.data).toString());
      var resuser = resp['user'];
      var rescategory = resp['category'];
      print(resp);
      print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
      print(resp['id']);
      print(resp['user_id']);
      print(resp['category_id']);
      print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
      print(resuser);
      print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
      print(resuser['id']);
      print(resuser['name']);

      getSinglePostModal singlePostModal = getSinglePostModal(
        heading: resp['heading'],
        summary: resp['summary'],
        videoLink: resp['video_link'],
        type: resp['type'],
        pdf: resp['pdf'],
        id: resp['id'],
        timeStamp: resp['created_at'],
        articleLink: resp['article_link'],
        likes: resp['likes'],
        dislikes: resp['dislikes'],
        commentsCount: resp['comments_count'],
        userLike: resp['user_like'],
        userDislike: resp['user_dislike'],
      );
      postModel = singlePostModal;
      /// UserModel
      UserModel userModel = UserModel(
        id: resuser['id'],
        name: resuser['name'],
        email: resuser['email'],
        phone: resuser['phone'],
        credibility: resuser['credibility'],
        dob: resuser['dob'],
        apiToken: resuser['api_token'],
        status: resuser['status'],
        badge: resuser['badge'],
        badgeStatus: resuser['badge_status'],
        image: resuser['image'],
        cover: resuser['cover'],
        city: resuser['city'],
        qualification: resuser['qualification'],
        occupation: resuser['occupation'],
        userFollowers: resuser['user_followers'],
        userFollowing: resuser['user_following'],
        isFollowing: resuser['is_following'],
      );
      user = userModel;
    }

  } catch (e) {
    //Catch
    print('Something Wrong');
    print(e);
  }
  return '';
}
// Todo Extra
// void getSinglePost() async {
//   setState(() {
//     _loading = true;
//   });
//
//   try {
//     var postId = widget.postID.toString();
//     // Try
//     final _postData = Provider.of<PostProvider>(context, listen: false);
//     Map<String, String> getpost = {
//       'post_id': postId,
//     };
//     Map results = await NetworkHelper().getSinglePost(getpost);
//     if (!results['error']) {
//       PostModel post = results[''];
//       _postData.post = post;
//       SnackBarHelper.showSnackBarWithoutAction(context, message: 'Success');
//     } else {
//       SnackBarHelper.showSnackBarWithoutAction(context,
//           message: results['errorData']);
//     }
//   } catch (e) {
//     // Catch
//     SnackBarHelper.showSnackBarWithoutAction(context, message: e.toString());
//   }
//   setState(() {
//     _loading = false;
//   });
// }
// Todo Extra
}