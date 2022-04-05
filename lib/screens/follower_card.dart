import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowerCard extends StatelessWidget {
  const FollowerCard({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final _userData = Provider.of<UserProvider>(context, listen: false);
        final myUser = _userData.user;
        Navigator.pushNamed(
            context, myUser.id == user.id ? myProfileRoute : showUserRoute,
            arguments: {'user': user});
      },
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
              color: kTextColorLightGrey,
              width: 0.7,
            ))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ClipOval(
                child: FadeInImage(
                  placeholder: const AssetImage(userAvatar),
                  image: NetworkImage(
                    user.image,
                  ),
                  height: 50.0,
                  width: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              user.name,
              maxLines: 1,
              style: const TextStyle(
                color: kPrimaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
