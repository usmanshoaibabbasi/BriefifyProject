import 'package:badges/badges.dart';
import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:briefify/screens/term_and_condition.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/drawer_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// User Provider
    final _userData = Provider.of<UserProvider>(context);
    final UserModel _user = _userData.user;

    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 130,
                child: DrawerHeader(
                    margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Display Full Image Profile
                                Navigator.pushNamed(context, ImgeScreenProfile);
                              },
                              child: Badge(
                                badgeContent: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 10,
                                ),
                                showBadge: _user.badgeStatus == 2,
                                position:
                                    BadgePosition.bottomEnd(bottom: 8, end: -3),
                                badgeColor: kPrimaryColorLight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child: FadeInImage(
                                    placeholder: const AssetImage(userAvatar),
                                    image: NetworkImage(_user.image),
                                    fit: BoxFit.cover,
                                    imageErrorBuilder:
                                        (context, object, trace) {
                                      return Image.asset(
                                        appLogo,
                                        height: 60,
                                        width: 60,
                                      );
                                    },
                                    height: 80,
                                    width: 80,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  _user.userFollowers.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Followers',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  _user.userFollowing.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Followings',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        // const SizedBox(height: 10),
                        // Text(
                        //   _user.name,
                        //   style: const TextStyle(
                        //     fontWeight: FontWeight.normal,
                        //     fontSize: 20,
                        //     color: kPrimaryTextColor,
                        //   ),
                        // ),
                      ],
                    )),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 50, 0, 5),
                    child: const Text(
                      'Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              DrawerItem(
                  icon: CupertinoIcons.person_fill,
                  col: Colors.blue,
                  title: 'Profile',
                  onTap: () {
                    Navigator.pushNamed(context, myProfileRoute);
                  }),
              DrawerItem(
                  icon: CupertinoIcons.check_mark_circled_solid,
                  col: Colors.blue,
                  title: 'Verification',
                  onTap: () {
                    Navigator.pushNamed(context, profileVerificationRoute);
                  }),
              DrawerItem(
                  icon: CupertinoIcons.folder_circle_fill,
                  col: Colors.blue,
                  title: 'Categories',
                  onTap: () {
                    Navigator.pushNamed(context, categoriesRoute);
                  }),
              DrawerItem(
                  icon: CupertinoIcons.folder_circle_fill,
                  col: Colors.blue,
                  title: 'Wallet',
                  onTap: () {
                    Navigator.pushNamed(context, walletRoute);
                  }),
              DrawerItem(
                  icon: CupertinoIcons.arrow_down_left_circle_fill,
                  col: Colors.blue,
                  title: 'Logout',
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    await Prefs().logoutUser();
                    Navigator.pushNamedAndRemoveUntil(
                        context, welcomeRoute, ModalRoute.withName(homeRoute));
                  }),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 50, 0, 5),
                    child: const Text(
                      'Links',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              DrawerItem(
                  icon: CupertinoIcons.info_circle_fill,
                  col: Colors.blue,
                  title: 'About Us',
                  onTap: () {
                    launchurl1(url1: 'https://briefify.io/');
                  }),
              DrawerItem(
                  icon: CupertinoIcons.question_circle_fill,
                  col: Colors.blue,
                  title: 'FAQs',
                  onTap: () {
                    launchurl1(url1: 'https://briefify.io/');
                  }),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 50, 0, 5),
                    child: const Text(
                      'Legal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              DrawerItem(
                  icon: CupertinoIcons.folder_circle_fill,
                  col: Colors.blue,
                  title: 'Privacy Policy',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TermAndConditionScreen()),
                    );
                  }),
              DrawerItem(
                  icon: CupertinoIcons.minus_circle_fill,
                  col: Colors.blue,
                  title: 'Terms and Conditions',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TermAndConditionScreen()),
                    );
                  }),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  void launchurl1({url1}) async {
    // For Url Launch Ios Info.plist
    // For Url Launch Android AndroidManifest
    var url = url1;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ImgScreenProfile extends StatelessWidget {
  const ImgScreenProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserProvider>(context);
    final user = _userData.user;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.5,
                child: Image(
                  image: NetworkImage(
                    user.image,
                  ),
                  height: double.infinity,
                  width: double.infinity,
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
            ))
          ],
        ),
      ),
    );
  }
}
