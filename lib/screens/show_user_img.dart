import 'package:briefify/data/constants.dart';
import 'package:briefify/models/user_model.dart';
import 'package:flutter/material.dart';

// ShowOtherUserCoverPhoto Class

class ShowOtherUserCoverPhoto extends StatefulWidget {
  final UserModel user;
  ShowOtherUserCoverPhoto({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ShowOtherUserCoverPhoto> createState() => _ShowOtherUserCoverPhotoState();
}

class _ShowOtherUserCoverPhotoState extends State<ShowOtherUserCoverPhoto> {
  @override
  void initState() {
    var a = widget.user.id;
    print('user from Modedl');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Image(
                  image: NetworkImage(
                    widget.user.cover,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: kPrimaryColorLight,
                        borderRadius: BorderRadius.circular(200),
                      ),
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                      )),
                )
            )
          ],
        ),
      ),
    );
  }
}

// OtherUserProfilePhoto Class

class OtherUserProfilePhoto extends StatefulWidget {
  final UserModel user;
  const OtherUserProfilePhoto({Key? key,required this.user,}) : super(key: key);

  @override
  _OtherUserProfilePhotoState createState() => _OtherUserProfilePhotoState();
}

class _OtherUserProfilePhotoState extends State<OtherUserProfilePhoto> {
  @override
  void initState() {
    var a = widget.user.id;
    print('user from Modedl');
    print(a);
    // print(a);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Image(
                  image: NetworkImage(
                    widget.user.image,
                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Positioned(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: kPrimaryColorLight,
                        borderRadius: BorderRadius.circular(200),
                      ),
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                      )),
                )
            )
          ],
        ),
      ),
    );
  }
}