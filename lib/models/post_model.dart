import 'package:briefify/models/category_model.dart';
import 'package:briefify/models/user_model.dart';

class PostModel {
  final CategoryModel category;
  final String heading;
  final String summary;
  final String videoLink;
  final String type;
  final String pdf;
  final int id;
  final String timeStamp;
  final String articleLink;
  final UserModel user;
  int likes;
  int dislikes;
  int commentsCount;
  bool userLike;
  bool userDislike;

  PostModel(
    this.category,
    this.heading,
    this.summary,
    this.videoLink,
    this.type,
    this.pdf,
    this.id,
    this.timeStamp,
    this.articleLink,
    this.user,
    this.likes,
    this.dislikes,
    this.commentsCount,
    this.userLike,
    this.userDislike,
  );

  factory PostModel.fromJson(jsonObject) {
    final CategoryModel category =
        CategoryModel.fromJson(jsonObject['category']);
    final String heading = jsonObject['heading'];
    final String summary = jsonObject['summary'];
    final String videoLink = jsonObject['video_link'] ?? '';
    final String type = jsonObject['type'];
    final String pdf = jsonObject['pdf'] ?? '';
    final String articleLink = jsonObject['article_link'] ?? '';
    final int id = jsonObject['id'];
    final String timeStamp = jsonObject['created_at'];
    final int likes = jsonObject['likes'];
    final int dislikes = jsonObject['dislikes'];
    final int commentsCount = jsonObject['comments_count'];
    final bool userLike = jsonObject['user_like'];
    final bool userDislike = jsonObject['user_dislike'];
    final UserModel user = UserModel.fromJson(jsonObject['user']);
    return PostModel(
      category,
      heading,
      summary,
      videoLink,
      type,
      pdf,
      id,
      timeStamp,
      articleLink,
      user,
      likes,
      dislikes,
      commentsCount,
      userLike,
      userDislike,
    );
  }
}
