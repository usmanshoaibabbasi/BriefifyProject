import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

import '../data/constants.dart';
import '../data/image_paths.dart';
import '../data/routes.dart';
import '../data/text_fields_decorations.dart';
import '../helpers/network_helper.dart';
import '../helpers/snack_helper.dart';
import '../models/user_model.dart';
import '../widgets/button_one.dart';

class ReportUser extends StatefulWidget {
  final int postid;
  final int userid;

  const ReportUser({Key? key, required this.postid, required this.userid})
      : super(key: key);

  @override
  _ReportUserState createState() => _ReportUserState();
}

class _ReportUserState extends State<ReportUser> {
  final TextEditingController _descriptionController = TextEditingController();
  int groupValue = 0;
  String selectedvalue = 'Nudity';
  final maxLines = 5;
  late int postid;
  late int userid;
  bool _loading = false;

  @override
  void initState() {
    userid = widget.userid;
    postid = widget.postid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 3),
                                  color: Colors.greenAccent.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Please Select Problems',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "If You Are In Immediate Danger,Get Help Before Reporting To Briefify. Don't wait",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 3),
                                  color: Colors.white70.withOpacity(0.1),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  child: myRadioButton(
                                    title: "Nudity",
                                    value: 0,
                                    onChanged: (newValue) =>
                                        setState(() => groupValue = newValue,),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  child: myRadioButton(
                                    title: "Violence",
                                    value: 1,
                                    onChanged: (newValue) =>
                                        setState(() => groupValue = newValue),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  child: myRadioButton(
                                    title: "Harassment",
                                    value: 2,
                                    onChanged: (newValue) =>
                                        setState(() => groupValue = newValue),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  child: myRadioButton(
                                    title: "Suicide or Self-Injury",
                                    value: 3,
                                    onChanged: (newValue) =>
                                        setState(() => groupValue = newValue),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  child: myRadioButton(
                                    title: "False Information",
                                    value: 4,
                                    onChanged: (newValue) =>
                                        setState(() => groupValue = newValue),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  child: myRadioButton(
                                    title: "Spam",
                                    value: 5,
                                    onChanged: (newValue) =>
                                        setState(() => groupValue = newValue),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  child: myRadioButton(
                                    title: "Terrorism",
                                    value: 6,
                                    onChanged: (newValue) =>
                                        setState(() => groupValue = newValue),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  child: myRadioButton(
                                    title: "Hate Speech",
                                    value: 7,
                                    onChanged: (newValue) =>
                                        setState(() => groupValue = newValue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(12),
                            height: maxLines * 24.0,
                            child: TextField(
                              controller: _descriptionController,
                              maxLines: maxLines,
                              decoration: kPostInputDecoration.copyWith(
                                hintText: "Description",
                                hintStyle: TextStyle(fontSize: 16.0, color: kPrimaryColorLight),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonOne(
                          title: 'Report',
                          onPressed: () {
                            if(groupValue == 0)
                            {
                              selectedvalue = 'Nudity';
                            }
                            if(groupValue == 1)
                            {
                              selectedvalue = 'Violence';
                            }
                            if(groupValue == 2)
                            {
                              selectedvalue = 'Harassment';
                            }
                            if(groupValue == 3)
                            {
                              selectedvalue = 'Suicide or Self-Injury';
                            }
                            if(groupValue == 4)
                            {
                              selectedvalue = 'False Information';
                            }
                            if(groupValue == 5)
                            {
                              selectedvalue = 'Spam';
                            }
                            if(groupValue == 6)
                            {
                              selectedvalue = 'Terrorism';
                            }
                            if(groupValue == 7)
                            {
                              selectedvalue = 'Hate Speech';
                            }
                            if (validData()) {
                              ReportUser();
                            };
                            // print(jsonDecode(encodedSummary));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: kPrimaryColorLight,
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: const Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.white,
                  )),
            )),
          ],
        ));
  }

  Widget myRadioButton(
      {required String title, required int value, var onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Text(title),
    );
  }

  // Validation Of TextField
  bool validData() {
    if (_descriptionController.text.isEmpty) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Please enter Description');
      return false;
    }
    return true;
  }

  // Send Data To DataBase Function
  void ReportUser() async {
    setState(() {
      _loading = true;
    });
    try{
      Map results = await NetworkHelper().reportUser(
        _descriptionController.text,
        selectedvalue,
        userid,
        postid,
      );
      if (!results['error']) {
        SnackBarHelper.showSnackBarWithoutAction(context, message: 'Post Reported');
        // Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, homeRoute, (route) => false);
      } else {
        SnackBarHelper.showSnackBarWithoutAction(context,
            message: results['errorData']);
      }

    } catch(e) {
      SnackBarHelper.showSnackBarWithoutAction(context, message: e.toString());

    }
    setState(() {
      _loading = false;
    });
  }
}
