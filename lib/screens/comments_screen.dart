import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/text_fields_decorations.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/comment_model.dart';
import 'package:briefify/models/post_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:briefify/widgets/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key, required this.post}) : super(key: key);
  final PostModel post;
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentFieldController = TextEditingController();
  List<CommentModel> _comments = List.empty(growable: true);

  bool _loading = false;
  bool _error = false;

  @override
  void initState() {
    getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _loading
                ? const SpinKitCircle(
                    size: 50,
                    color: kPrimaryColorLight,
                  )
                : _error
                    ? Center(
                        child: GestureDetector(
                            onTap: () {
                              getComments();
                            },
                            child: Image.asset(
                              errorIcon,
                              height: 60,
                            )),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: SafeArea(
                              child: _comments.isEmpty
                                  ? const Center(
                                      child: Text('Be the first to comment'),
                                    )
                                  : ListView.builder(
                                      reverse: true,
                                      itemBuilder: (context, index) =>
                                          CommentCard(
                                              comment: _comments[index]),
                                      itemCount: _comments.length,
                                    ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: TextField(
                                  controller: _commentFieldController,
                                  decoration: kPostInputDecoration.copyWith(
                                    labelText: 'Write here',
                                  ),
                                  minLines: 1,
                                  maxLines: 3,
                                ),
                              )),
                              ButtonOne(
                                title: 'Post',
                                onPressed: () {
                                  comment();
                                },
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ],
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
        ));
  }

  void createPostComment(String comment, CommentModel commentModel) async {
    try {
      Map results = await NetworkHelper()
          .createPostComment(widget.post.id.toString(), comment);
      if (!results['error']) {
        commentModel = results['comment'];
      }
      // Ignore the error
    } catch (ignore) {
      // Ignore the response
    }
  }

  void getComments() async {
    _error = await false;
    setState(() {
      _loading = true;
    });
    try {
      Map results =
          await NetworkHelper().getPostComments(widget.post.id.toString());
      if (!results['error']) {
        print('working fine');
        _comments = results['comments'];
      } else {
        _error = true;
        SnackBarHelper.showSnackBarWithoutAction(context,
            message: results['errorData']);
      }
    } catch (e) {
      _error = true;
      SnackBarHelper.showSnackBarWithoutAction(context, message: e.toString());
    }
    setState(() {
      _loading = false;
    });
  }

  void comment() {
    if (_commentFieldController.text.trim().isNotEmpty) {
      final _userData = Provider.of<UserProvider>(context, listen: false);
      final _user = _userData.user;
      CommentModel commentModel = CommentModel(0, widget.post.id,
          _commentFieldController.text, 'Just now', _user, 0);
      createPostComment(_commentFieldController.text, commentModel);
      _comments.insert(0, commentModel);
      widget.post.commentsCount = widget.post.commentsCount + 1;
      setState(() {
        _commentFieldController.text = '';
      });
    }
  }
}
