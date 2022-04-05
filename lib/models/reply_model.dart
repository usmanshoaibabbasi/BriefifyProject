import 'package:briefify/models/user_model.dart';

class ReplyModel {
  final int id;
  final String text;
  final UserModel user;
  final String timeStamp;

  ReplyModel(this.id, this.text, this.user, this.timeStamp);

  factory ReplyModel.fromJson(jsonReply) {
    final int id = jsonReply['id'];
    final String text = jsonReply['text'];
    final UserModel user = UserModel.fromJson(jsonReply['user']);
    final String timeStamp = jsonReply['created_at'];
    return ReplyModel(id, text, user, timeStamp);
  }
}
