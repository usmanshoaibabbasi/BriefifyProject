class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String credibility;
  final String dob;
  final String apiToken;
  final int status;
  final int badge;
  final int badgeStatus;
  final String image;
  final String cover;
  final String city;
  final String qualification;
  final String occupation;
  int userFollowers;
  int userFollowing;
  bool isFollowing;

  UserModel(

      this.id,
      this.name,
      this.email,
      this.phone,
      this.credibility,
      this.dob,
      this.apiToken,
      this.status,
      this.badge,
      this.badgeStatus,
      this.image,
      this.cover,
      this.city,
      this.qualification,
      this.occupation,
      this.userFollowers,
      this.userFollowing,
      this.isFollowing);

  factory UserModel.fromJson(jsonObject) {

    final int id = jsonObject['id'];
    final String name = jsonObject['name'];
    final String email = jsonObject['email'];
    final String phone = jsonObject['phone'];
    final String credibility = jsonObject['credibility'];
    final String dob = jsonObject['dob'];
    final String apiToken = jsonObject['api_token'];
    final int status = jsonObject['status'];
    final int badge = jsonObject['badge'];
    final int badgeStatus = jsonObject['badge_status'];
    final String image = jsonObject['image'];
    final String cover = jsonObject['cover'];
    final String city = jsonObject['city'] ?? '';
    final String qualification = jsonObject['qualification'] ?? '';
    final String occupation = jsonObject['occupation'] ?? '';
    final int userFollowers = jsonObject['user_followers'];
    final int userFollowing = jsonObject['user_following'];
    final bool isFollowing = jsonObject['is_following'] ?? false;


    return UserModel(id, name, email, phone, credibility, dob, apiToken, status, badge, badgeStatus, image,
        cover, city, qualification, occupation, userFollowers, userFollowing, isFollowing);
  }
}
