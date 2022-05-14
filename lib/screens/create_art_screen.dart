import 'dart:io';

import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/urls.dart';
import 'package:briefify/helpers/file_picker_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class CreateArtScreen extends StatefulWidget {
  const CreateArtScreen({Key? key}) : super(key: key);

  @override
  State<CreateArtScreen> createState() => _CreateArtScreenState();
}

class _CreateArtScreenState extends State<CreateArtScreen> {
  XFile? _image;
  bool progress = false;
  @override
  Widget build(BuildContext context) {
    var totalheight = MediaQuery.of(context).size.height;
    var totalwidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0XffEDF0F4),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
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
                    SizedBox(height: totalheight*0.03,),
                    Container(
                      width: totalwidth,
                      decoration: const BoxDecoration(
                        color: Color(0xffFFFFFF),
                        borderRadius: BorderRadius.all(Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: 20,),
                            height: totalheight*0.07,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _image == null;
                                      Navigator.pushReplacementNamed(context, createArtRoute);

                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: _image != null
                                          ?
                                      kPrimaryColorLight
                                          :
                                      kTextColorLightGrey,
                                      borderRadius: BorderRadius.circular(200),
                                    ),
                                    child: const Icon(FontAwesomeIcons.xmark,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              XFile? file = await FilePickerHelper().getImage();
                              if (file != null) {
                                setState(() {
                                  var a = file.path.split('/').last.toString();
                                  var b = a.length;
                                  print('kkkkkkkkkkkk');
                                  print(a);
                                  print(b);
                                  print('kkkkkkkkkkkkjjj');
                                  var c = a.substring(b-3,b-0);
                                  print('ccccccccccccccccccccccccc');
                                  print(c);
                                  print('cccccccccccccccccccccccccccccc');
                                  if (c == 'jpg' || c == 'png') {
                                    _image = file;
                                    SnackBarHelper
                                        .showSnackBarWithoutAction(
                                        context,
                                        message: 'Image selected');
                                  } else {
                                    SnackBarHelper
                                        .showSnackBarWithoutAction(
                                        context,
                                        message:
                                        'Only jpg, and png accepted');
                                  }
                                });
                              }
                            },
                            child: Container(
                              width: totalwidth,
                              height: totalheight*0.27,
                              margin: EdgeInsets.fromLTRB(10, totalheight*0.03, 10, totalheight*0.03),
                              decoration: const BoxDecoration(
                                color: Color(0xffFFFFFF),
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: _image != null
                                  ?
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.file(
                                  File(_image!.path),
                                  fit: BoxFit.fill,
                                ),
                              )
                                  :
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('Select Image',
                                    style: TextStyle(
                                      color: kTextColorLightGrey,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Icon(FontAwesomeIcons.camera,
                                  size: 50,
                                  color: kTextColorLightGrey,),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  _image == null
                                      ? Icons.check_circle_outline
                                      : Icons.check_circle,
                                  color: _image == null
                                      ? kTextColorLightGrey
                                      : kPrimaryColorLight,
                                ),
                                ButtonOne(
                                  title: 'Post',
                                  onPressed: () {
                                    if (validData()) {
                                      createPost(
                                      _image,
                                      );
                                    }
                                  },
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: totalheight*0.03,),
                        ],
                      ),
                    ),
                  ],
                ),
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
    if (_image == null) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Please select image');
      return false;
    }
    return true;
  }

  Future<String> createPost (var _image) async {
    setState(() {
      progress = true;
    });
    final String apiToken = await Prefs().getApiToken();
    String type = 1.toString();
    print(apiToken);
    var filename = _image.path.split('/').last;
    print('file name');
    print(filename);
    var formData = FormData.fromMap({
      'art_image': await MultipartFile.fromFile(_image.path,
          filename: filename, contentType:
          MediaType('image', 'png')),
      'type': type,
    });
    Dio dio = Dio();
    Response responce;
    try {
      print('Enter in try');
      responce = await dio.post(
        uCreateArt,
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
              message: 'Posted');
          _image == null;
          Navigator.pushReplacementNamed(context, createArtRoute);
        });
      }
    } catch (e) {
      print(e);
      return 'some thing wrong';
    }
    setState(() {
      progress = true;
    });
    return 'some thing wrong';
  }
}
