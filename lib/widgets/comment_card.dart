import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/models/comment_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;

  const CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 10, 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(
          color: kTextColorLightGrey,
          width: 0.5,
        )),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              final _userData =
                  Provider.of<UserProvider>(context, listen: false);
              final myUser = _userData.user;
              Navigator.pushNamed(context,
                  myUser.id == comment.user.id ? myProfileRoute : showUserRoute,
                  arguments: {'user': comment.user});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: FadeInImage(
                  placeholder: const AssetImage(userAvatar),
                  image: NetworkImage(comment.user.image),
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
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      final _userData =
                          Provider.of<UserProvider>(context, listen: false);
                      final myUser = _userData.user;
                      Navigator.pushNamed(
                          context,
                          myUser.id == comment.user.id
                              ? myProfileRoute
                              : showUserRoute,
                          arguments: {'user': comment.user});
                    },
                    child: Text(
                      comment.user.name,
                      maxLines: 1,
                      style: const TextStyle(
                        color: kPrimaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    comment.timeStamp,
                    maxLines: 1,
                    style: const TextStyle(
                      color: kSecondaryTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  comment.comment,
                  style: const TextStyle(
                    color: kPrimaryTextColor,
                    fontSize: 14,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: GestureDetector(
                  onTap: () {
                    if (comment.id != 0) {
                      Navigator.pushNamed(context, repliesRoute,
                          arguments: {'comment': comment});
                    }
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.reply,
                        color: kSecondaryTextColor,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Reply',
                        style: TextStyle(
                          color: kSecondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
