import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/screens/follower_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  bool _loading = false;
  bool _error = false;
  List<UserModel> following = List.empty(growable: true);

  @override
  void initState() {
    getFollowing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Following',
          style: TextStyle(
            color: kPrimaryTextColor,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: kPrimaryColorLight,
                borderRadius: BorderRadius.circular(200),
              ),
              child: const Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              )),
          onPressed: () {
            Navigator.pop(context);
          },
          color: kSecondaryColorDark,
          padding: const EdgeInsets.all(0),
        ),
      ),
      backgroundColor: Colors.white,
      body: _loading
          ? const Center(
              child: SpinKitCircle(
                color: kPrimaryColorLight,
                size: 50,
              ),
            )
          : _error
              ? Center(
                  child: GestureDetector(
                      onTap: () {
                        getFollowing();
                      },
                      child: Image.asset(
                        errorIcon,
                        height: 40,
                      )),
                )
              : following.isEmpty
                  ? const Center(child: Text('No User Found'))
                  : ListView.builder(
                      itemBuilder: (context, index) =>
                          FollowerCard(user: following[index]),
                      itemCount: following.length,
                    ),
    );
  }

  void getFollowing() async {
    _error = await false;
    setState(() {
      _loading = true;
    });
    try {
      Map results =
          await NetworkHelper().getFollowing(widget.user.id.toString());
      if (!results['error']) {
        following = results['following'];
      } else {
        _error = true;
      }
    } catch (e) {
      _error = true;
    }
    setState(() {
      _loading = false;
    });
  }
}
