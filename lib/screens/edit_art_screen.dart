import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/text_fields_decorations.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/urls.dart';
import 'package:dio/dio.dart';

class EditArtScreen extends StatefulWidget {
  final int postId;
  final int userId;
  final String heading;
  final String artimg;
  const EditArtScreen({
    required this.postId,
    required this.userId,
    required this.heading,
    required this.artimg,
    Key? key}) : super(key: key);

  @override
  State<EditArtScreen> createState() => _EditArtScreenState();
}

class _EditArtScreenState extends State<EditArtScreen> {
  bool _loading = false;
  bool _error = false;
  XFile? _image;
  bool progress = false;

  final TextEditingController _headingController = TextEditingController();
  late String postId;
  late int userId;

  @override
  void initState() {
    postId = widget.postId.toString();
    userId = widget.userId;
    String heading = widget.heading;
    String artimg = widget.artimg;
    setState(() {
      _headingController.text = heading;
    });
    super.initState();
  }
  Widget build(BuildContext context) {
    var totalheight = MediaQuery.of(context).size.height;
    var totalwidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0XffEDF0F4),
          body: Stack(
            children: [
              Column(
                children: [
                  /// First Container
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    height: totalheight*0.15,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: kPrimaryColorLight,
                                borderRadius: BorderRadius.circular(200),
                              ),
                              child: const Icon(
                                Icons.arrow_back_outlined,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                  /// SizedBox After First Container
                  SizedBox(height: totalheight*0.02,),
                  /// Second Container
                  Container(
                    width: totalwidth,
                    height: totalheight*0.25,
                    decoration: const BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(20),
                      ),
                    ),
                    child: Container(
                      height: double.maxFinite,
                      margin: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _headingController,
                        decoration: kPostInputDecoration.copyWith(
                          labelText: 'Summary',
                          alignLabelWithHint: true,
                        ),
                        maxLines: 10,
                        maxLength: 250,
                      ),
                    ),
                  ),
                  /// SizedBox After Second Container
                  SizedBox(height: totalheight*0.02,),
                  /// Third Container
                  Container(
                    width: totalwidth,
                    height: totalheight*0.49,
                    decoration: const BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: totalheight*0.02),
                        Container(
                          width: totalwidth,
                          height: totalheight*0.36,
                          margin:  EdgeInsets.fromLTRB(10, 0, 10, totalheight*0.02),
                          decoration: const BoxDecoration(
                            color: Color(0xffFFFFFF),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: FadeInImage(
                              placeholder: const AssetImage(userAvatar),
                              image: NetworkImage(widget.artimg),
                              fit: BoxFit.fill,
                              imageErrorBuilder: (context, object, trace) {
                                return Image.asset(
                                  appLogo,
                                  height: double.infinity,
                                  width: double.infinity,
                                );
                              },
                              height: double.infinity,
                              width: double.infinity,
                            ),
                          )
                        ),
                        /// Forth Container
                        Container(
                          height: totalheight*0.07,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: kPrimaryColorLight,
                              ),
                              ButtonOne(
                                title: 'Update',
                                onPressed: () {
                                  if (validData()) {
                                    updateArtPost(
                                    );
                                  }
                                },
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: totalheight*0.02,),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: progress == true ?
                const SpinKitCircle(
                  size: 50,
                  color: kPrimaryColorLight,
                ):
                Container(),
              ),
            ],
          ),
        )
    );
  }
  bool validData() {
    if (_headingController.text.trim() == null || _headingController.text.trim() == '') {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Please enter summary');
      return false;
    }
    if (_headingController.text.trim().length>250) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Max 250 characters are allowed');
      return false;
    }
    return true;
  }

  Future<String> updateArtPost () async {
    setState(() {
      progress = true;
    });
    final String apiToken = await Prefs().getApiToken();
    var formData = FormData.fromMap({
      'api_token': apiToken,
      'id': postId,
      'heading': _headingController.text.trim(),
    });
    Dio dio = Dio();
    Response responce;
    try {
      print('Enter in try');
      responce = await dio.post(
        uUpdateArt,
        options: Options(headers: {
          "Authorization": "Bearer $apiToken"}),
        data: formData,
      );
      print('Enter in 200');
      if (responce.data['error'] == false) {
        print('enter in 200');
        var res1 = responce.data['post'];
        setState(() {
          SnackBarHelper.showSnackBarWithoutAction(context,
              message: 'Art updated');
          _image == null;
          Navigator.pushNamedAndRemoveUntil(context, homeRoute, (route) => false);
        });
      }
    } catch (e) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Something wrong');
      print(e);
      return 'some thing wrong';
    }
    setState(() {
      progress = true;
    });
    return 'some thing wrong';
  }
}
