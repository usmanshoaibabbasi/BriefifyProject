import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/models/user_model.dart';
import 'package:briefify/screens/follower_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  bool _loading = false;
  bool _error = false;
  List<UserModel> followers = List.empty(growable: true);

  @override
  void initState() {
    getFollowers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Followers',
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
                        getFollowers();
                      },
                      child: Image.asset(
                        errorIcon,
                        height: 40,
                      )),
                )
              : followers.isEmpty
                  ? const Center(child: Text('No User Found'))
                  : ListView.builder(
                      itemBuilder: (context, index) =>
                          FollowerCard(user: followers[index]),
                      itemCount: followers.length,
                    ),
    );
  }

  void getFollowers() async {
    _error = await false;
    setState(() {
      _loading = true;
    });
    try {
      Map results =
          await NetworkHelper().getFollowers(widget.user.id.toString());
      if (!results['error']) {
        followers = results['followers'];
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
