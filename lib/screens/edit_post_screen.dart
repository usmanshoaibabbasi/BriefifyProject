import 'dart:convert';

import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/text_fields_decorations.dart';
import 'package:briefify/helpers/file_picker_helper.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/category_model.dart';
import 'package:briefify/screens/create_post_screen.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:validators/validators.dart';

class EditPostScreen extends StatefulWidget {
  final int postId;
  final int userId;
  final String heading;
  final String summary;
  final String videolink;
  final String ariclelink;
  final String category;

  const EditPostScreen({
    required this.postId,
    required this.userId,
    required this.heading,
    required this.summary,
    required this.videolink,
    required this.ariclelink,
    required this.category,
    Key? key}) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {

  String _selectedCategory = '';
  List<CategoryModel> _categories = [];
  bool _loading = false;
  bool _error = false;

  late quil.QuillController _summaryController = quil.QuillController.basic();

  final TextEditingController _headingController = TextEditingController();
  final TextEditingController _articleLinkController = TextEditingController();
  final TextEditingController _videoLinkController = TextEditingController();
  late int postId;
  late int userId;
  var a;

  @override
  void initState() {

    postId = widget.postId;
    userId = widget.userId;
    String heading = widget.heading;
    String summary = widget.summary;
    String videolink = widget.videolink;
    String ariclelink = widget.ariclelink;
    // String category = widget.category;

    getCategories();
    setState(() {
      _headingController.text = heading;
      _articleLinkController.text = ariclelink;
      _videoLinkController.text = videolink;
      // Document();
      _summaryController = quil.QuillController(
        document: quil.Document.fromJson(json.decode(summary)),
        selection: TextSelection.collapsed(offset: 0)
      );
    });
    a = categorylist2.indexOf(widget.category.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _loading
                ? const SpinKitCircle(
              size: 50,
              color: kPrimaryColorLight,
            )
                : _error
                ? Center(
                child: GestureDetector(
                    onTap: () {
                      getCategories();
                    },
                    child: Image.asset(
                      errorIcon,
                      height: 80,
                    )))
                : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Image.asset(
                        appLogo,
                        height: 50,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Please select category',
                        style: TextStyle(
                          color: kSecondaryColorDark,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: DropdownSearch<String>(
                        items: categorylist2,
                        mode: Mode.MENU,
                        showSearchBox: true,
                        maxHeight:
                        MediaQuery.of(context).size.height * 0.5,
                        selectedItem: categorylist2[a],
                        dropDownButton: const Icon(
                          Icons.keyboard_arrow_down_sharp,
                          size: 30,
                          color: kPrimaryColorLight,
                        ),
                        dropdownSearchDecoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                              10, 7, 10, 7),
                          errorStyle: TextStyle(),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: kPrimaryColorLight,
                              )),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: kPrimaryColorLight,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: kPrimaryColorLight,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColorLight,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0))),
                        ),
                        onChanged: (String? v) {
                          setState(() {
                            _selectedCategory =
                                v ?? categorylist2.toString();
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: _headingController,
                        decoration: kPostInputDecoration.copyWith(
                          labelText: 'Heading',
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Summary',
                        style: TextStyle(
                          color: kSecondaryColorDark,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    quil.QuillToolbar.basic(
                      controller: _summaryController,
                      showImageButton: false,
                      showVideoButton: false,
                      showCameraButton: false,
                      // showHistory: false,
                      // Todo Here i have made changes for Error
                    ),
                    Container(
                      height: 150,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kPrimaryColorLight),
                      ),
                      child: quil.QuillEditor.basic(
                        controller: _summaryController,
                        readOnly: false,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: _articleLinkController,
                        decoration: kPostInputDecoration.copyWith(
                          labelText: 'Article link',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: _videoLinkController,
                        decoration: kPostInputDecoration.copyWith(
                          labelText: 'Video Description link',
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(10),
                    //   child: Row(
                    //     mainAxisAlignment:
                    //     MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       const Text(
                    //         'Select PDF File',
                    //         style: TextStyle(
                    //           color: kSecondaryColorDark,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 18,
                    //         ),
                    //       ),
                    //       GestureDetector(
                    //         onTap: () async {
                    //           final file =
                    //           await FilePickerHelper().getPDF();
                    //           if (file != null) {
                    //             setState(() {
                    //               pdfFile = file;
                    //             });
                    //           }
                    //         },
                    //         child: Container(
                    //             padding: const EdgeInsets.all(10),
                    //             alignment: Alignment.center,
                    //             child: Image.asset(
                    //               attachFileIcon,
                    //               height: 50,
                    //             )),
                    //       ),
                    //       Icon(
                    //         pdfFile == null
                    //             ? Icons.check_circle_outline
                    //             : Icons.check_circle,
                    //         color: pdfFile == null
                    //             ? kTextColorLightGrey
                    //             : kPrimaryColorLight,
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonOne(
                            title: 'Update Post',
                            onPressed: () {
                              if (validData()) {
                                updatePost();
                              }
                              // print(jsonDecode(encodedSummary));
                            },
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                )
            ),
          ],
        )
    );
  }

  List<DropdownMenuItem<String>> getDropDownCategories() {
    return List.generate(
        _categories.length,
            (final index) => DropdownMenuItem(
          child: Text(_categories[index].name),
          value: _categories[index].name,
        ));
  }

  void getCategories() async {
    _error = await false;
    setState(() {
      _loading = true;
    });
    try {
      Map results = await NetworkHelper().getCategories();
      if (!results['error']) {
        _categories = results['categories'];
        if (_categories.isNotEmpty) {
          _selectedCategory = _categories[0].name;
        }
      } else {
        SnackBarHelper.showSnackBarWithoutAction(context,
            message: results['errorData']);
        _error = true;
      }
    } catch (e) {
      SnackBarHelper.showSnackBarWithoutAction(context, message: e.toString());
      _error = true;
    }
    setState(() {
      _loading = false;
    });
  }

  bool validData() {
    if (_headingController.text.isEmpty) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Please enter heading');
      return false;
    }
    if (_summaryController.document.toPlainText().trim().isEmpty) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Please enter summary');
      return false;
    }
    if (_articleLinkController.text.isEmpty ||
        !isURL(_articleLinkController.text)) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Please enter valid article link');
      return false;
    }
    if (_videoLinkController.text.isNotEmpty &&
        !isURL(_videoLinkController.text)) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Please enter youtube video link');
      return false;
    }
    // Youtube Video Check
    // String urlcheck = 'http(?:s?):\/\/(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-\_]*)(&(amp;)?‌​[\w\?‌​=]*)?';

    return true;
  }

  void updatePost() async {

    setState(() {
      _loading = true;
    });
    try{
      Map results = await NetworkHelper().editPost(
        getCategoryID(),
        _headingController.text,
        jsonEncode(_summaryController.document.toDelta().toJson()),
        _articleLinkController.text,
        _videoLinkController.text,
        postId.toString(),
        userId.toString(),
      );
      if (!results['error']) {
        SnackBarHelper.showSnackBarWithoutAction(context, message: 'Post Updated');
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

  String getCategoryID() {
    for (int i = 0; i < _categories.length; i++) {
      if (_categories[i].name == _selectedCategory) {
        return _categories[i].id.toString();
      }
    }
    return '1';
  }

}
