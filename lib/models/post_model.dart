import 'package:briefify/models/category_model.dart';
import 'package:briefify/models/user_model.dart';

class PostModel {
  final CategoryModel category;
  var heading;
  var summary;
  var videoLink;
  var type;
  var art_image;
  var pdf;
  final int id;
  var timeStamp;
  var articleLink;
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
    this.art_image,
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
    var heading = jsonObject['heading'] ?? '';
    var summary = jsonObject['summary'] ?? '';
    var videoLink = jsonObject['video_link'] ?? '';
    var type = jsonObject['type'] ?? '';
    var art_image = jsonObject['art_image'];
    var pdf = jsonObject['pdf'] ?? '';
    var articleLink = jsonObject['article_link'] ?? '';
    final int id = jsonObject['id'];
    var timeStamp = jsonObject['created_at'] ?? '';
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
      art_image,
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
