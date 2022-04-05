import 'package:briefify/models/user_model.dart';

class CommentModel {
  final int id;
  final int postID;
  final String comment;
  final String timeStamp;
  final UserModel user;
  int repliesCount;

  CommentModel(this.id, this.postID, this.comment, this.timeStamp, this.user,
      this.repliesCount);

  factory CommentModel.fromJson(jsonComment) {
    final int id = jsonComment['id'];
    final int postID = jsonComment['post_id'];
    final String comment = jsonComment['comment'];
    final String timeStamp = jsonComment['created_at'];
    final UserModel user = UserModel.fromJson(jsonComment['user']);
    final int repliesCount = jsonComment['replies_count'];
    return CommentModel(id, postID, comment, timeStamp, user, repliesCount);
  }
}
