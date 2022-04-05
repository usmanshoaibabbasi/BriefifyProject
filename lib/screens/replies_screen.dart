import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/text_fields_decorations.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/comment_model.dart';
import 'package:briefify/models/reply_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:briefify/widgets/reply_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class RepliesScreen extends StatefulWidget {
  const RepliesScreen({Key? key, required this.comment}) : super(key: key);
  final CommentModel comment;
  @override
  _RepliesScreenState createState() => _RepliesScreenState();
}

class _RepliesScreenState extends State<RepliesScreen> {
  final TextEditingController _replyFieldController = TextEditingController();
  List<ReplyModel> _replies = List.empty(growable: true);

  bool _loading = false;
  bool _error = false;

  @override
  void initState() {
    getReplies();
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
                              getReplies();
                            },
                            child: Image.asset(
                              errorIcon,
                              height: 60,
                            )),
                      )
                    : Column(
                        children: [
                          SafeArea(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: kSecondaryColorLight,
                                          width: 0.5))),
                              padding:
                                  const EdgeInsets.fromLTRB(70, 22, 20, 22),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 90,
                                ),
                                child: Text(
                                  widget.comment.comment,
                                  style: const TextStyle(
                                    color: kPrimaryTextColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SafeArea(
                              child: _replies.isEmpty
                                  ? const Center(
                                      child: Text('Be the first to reply'),
                                    )
                                  : ListView.builder(
                                      reverse: true,
                                      itemBuilder: (context, index) =>
                                          ReplyCard(reply: _replies[index]),
                                      itemCount: _replies.length,
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
                                  controller: _replyFieldController,
                                  decoration: kPostInputDecoration.copyWith(
                                    labelText: 'Write here',
                                  ),
                                  minLines: 1,
                                  maxLines: 3,
                                ),
                              )),
                              ButtonOne(
                                title: 'Reply',
                                onPressed: () {
                                  reply();
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

  void createCommentReply(String comment) async {
    try {
      Map results = await NetworkHelper()
          .createCommentReply(widget.comment.id.toString(), comment);
      if (!results['error']) {
        // Ignore the error
      }
    } catch (ignore) {
      // Ignore the response
    }
  }

  void getReplies() async {
    _error = await false;
    setState(() {
      _loading = true;
    });
    try {
      Map results =
          await NetworkHelper().getCommentReplies(widget.comment.id.toString());
      if (!results['error']) {
        _replies = results['replies'];
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

  void reply() {
    if (_replyFieldController.text.trim().isNotEmpty) {
      createCommentReply(_replyFieldController.text);
      final _userData = Provider.of<UserProvider>(context, listen: false);
      final _user = _userData.user;
      ReplyModel replyModel =
          ReplyModel(0, _replyFieldController.text, _user, 'Just now');
      _replies.insert(0, replyModel);
      widget.comment.repliesCount = widget.comment.repliesCount + 1;
      setState(() {
        _replyFieldController.text = '';
      });
    }
  }
}
