class getSinglePostModal {
  String heading;
  String summary;
  String videoLink;
  String? type;
  String? pdf;
  int? id;
  var timeStamp;
  String articleLink;
  int likes;
  int dislikes;
  int commentsCount;
  bool userLike;
  bool userDislike;
  getSinglePostModal({
    required this.heading,
    required this.summary,
    required this.videoLink,
    this.type,
    this.pdf,
    this.id,
    required this.timeStamp,
    required this.articleLink,
    required this.likes,
    required this.dislikes,
    required this.commentsCount,
    required this.userLike,
    required this.userDislike,


  });
}

class CategoryModel {
  int? id;
  String? name;
  CategoryModel({
    this.id,
    this.name,
});
}

class UserModel {
  int id;
  String name;
  String? email;
  String? phone;
  String? credibility;
  String? dob;
  String? apiToken;
  int? status;
  int? badge;
  int? badgeStatus;
  String image;
  String? cover;
  String? city;
  String? qualification;
  String? occupation;
  int? userFollowers;
  int? userFollowing;
  bool? isFollowing;
  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.credibility,
    this.dob,
    this.apiToken,
    this.status,
    this.badge,
    this.badgeStatus,
    required this.image,
    this.cover,
    this.city,
    this.qualification,
    this.occupation,
    this.userFollowers,
    this.userFollowing,
    this.isFollowing
  });
}