import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/helpers/file_picker_helper.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/models/verification_status_model.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfileVerificationScreen extends StatefulWidget {
  const ProfileVerificationScreen({Key? key}) : super(key: key);

  @override
  _ProfileVerificationScreenState createState() =>
      _ProfileVerificationScreenState();
}

class _ProfileVerificationScreenState extends State<ProfileVerificationScreen> {
  FilePickerResult? document;
  late VerificationStatusModel verificationStatusModel;

  bool _error = false;
  bool _loading = true;

  @override
  void initState() {
    getVerificationStatus();
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
                              getVerificationStatus();
                            },
                            child: Image.asset(
                              errorIcon,
                              height: 80,
                            )))
                    : SafeArea(
                        child: SingleChildScrollView(
                          child: verificationStatusModel.badgeStatus !=
                                  verificationApproved
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      'Status : ' +
                                          verificationStatusModel.badgeStatus,
                                      style: TextStyle(
                                        color: verificationStatusModel
                                                    .badgeStatus ==
                                                verificationApproved
                                            ? kPrimaryColorLight
                                            : verificationStatusModel
                                                        .badgeStatus ==
                                                    verificationPending
                                                ? Colors.orange
                                                : verificationStatusModel
                                                            .badgeStatus ==
                                                        verificationDeclined
                                                    ? Colors.red
                                                    : kPrimaryTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text(
                                            'Verify My Account',
                                            style: TextStyle(
                                              color: kSecondaryColorDark,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              final file =
                                                  await FilePickerHelper()
                                                      .getDocument();
                                              if (file != null) {
                                                setState(() {
                                                  document = file;
                                                });
                                              }
                                            },
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                  attachFileIcon,
                                                  height: 50,
                                                )),
                                          ),
                                          Icon(
                                            document == null
                                                ? Icons.check_circle_outline
                                                : Icons.check_circle,
                                            color: document == null
                                                ? kTextColorLightGrey
                                                : kPrimaryColorLight,
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ButtonOne(
                                            title: verificationStatusModel
                                                        .badgeStatus ==
                                                    verificationPending
                                                ? 'Reapply'
                                                : verificationStatusModel
                                                            .badgeStatus ==
                                                        verificationDeclined
                                                    ? 'Reapply'
                                                    : 'Apply',
                                            onPressed: () {
                                              if (validData()) {
                                                applyForVerification();
                                              }
                                            },
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 50),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Text(
                                        '- For Students; Upload Student ID\n\n- For Professionals; Upload highest '
                                        'educational achievement e.g. degree, diploma, certificate, etc.',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: kPrimaryTextColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      'Status : ' +
                                          verificationStatusModel.badgeStatus,
                                      style: TextStyle(
                                        color: verificationStatusModel
                                                    .badgeStatus ==
                                                verificationApproved
                                            ? kPrimaryColorLight
                                            : verificationStatusModel
                                                        .badgeStatus ==
                                                    verificationPending
                                                ? Colors.orange
                                                : verificationStatusModel
                                                            .badgeStatus ==
                                                        verificationDeclined
                                                    ? Colors.red
                                                    : kPrimaryTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const Text(
                                      'Your Account is Verified',
                                      style: TextStyle(
                                        color: kSecondaryColorDark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
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
            )),
          ],
        ));
  }

  void getVerificationStatus() async {
    _error = false;
    setState(() {
      _loading = true;
    });
    try {
      Map results = await NetworkHelper().getVerificationStatus();
      if (!results['error']) {
        verificationStatusModel = results['verificationStatus'];
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
    if (document == null) {
      SnackBarHelper.showSnackBarWithoutAction(context,
          message: 'Please attach NIC back image');
      return false;
    }
    return true;
  }

  void applyForVerification() async {
    setState(() {
      _loading = true;
    });

    try {
      Map results = await NetworkHelper().applyForVerification(document!);
      if (!results['error']) {
        SnackBarHelper.showSnackBarWithoutAction(context,
            message: 'Please check your email for further process');
        Navigator.of(context).pop();
      } else {
        SnackBarHelper.showSnackBarWithoutAction(context,
            message: results['errorData']);
      }
    } catch (e) {
      SnackBarHelper.showSnackBarWithoutAction(context, message: e.toString());
    }
    setState(() {
      _loading = false;
    });
  }
}
