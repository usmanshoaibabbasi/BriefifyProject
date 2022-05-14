class UserModel {
  var id;
  var name;
  var email;
  var phone;
  var credibility;
  var dob;
  var apiToken;
  var status;
  var badge;
  var badgeStatus;
  var image;
  var cover;
  var city;
  var qualification;
  var occupation;
  var userFollowers;
  var userFollowing;
  var isFollowing;

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

    var id = jsonObject['id'];
    var name = jsonObject['name'];
    var email = jsonObject['email'];
    var phone = jsonObject['phone'];
    var credibility = jsonObject['credibility'];
    var dob = jsonObject['dob'];
    var apiToken = jsonObject['api_token'];
    var status = jsonObject['status'];
    var badge = jsonObject['badge'];
    var badgeStatus = jsonObject['badge_status'];
    var image = jsonObject['image'];
    var cover = jsonObject['cover'];
    var city = jsonObject['city'] ?? '';
    var qualification = jsonObject['qualification'] ?? '';
    var occupation = jsonObject['occupation'] ?? '';
    var userFollowers = jsonObject['user_followers'];
    var userFollowing = jsonObject['user_following'];
    var isFollowing = jsonObject['is_following'] ?? false;


    return UserModel(id, name, email, phone, credibility, dob, apiToken, status, badge, badgeStatus, image,
        cover, city, qualification, occupation, userFollowers, userFollowing, isFollowing);
  }
}
