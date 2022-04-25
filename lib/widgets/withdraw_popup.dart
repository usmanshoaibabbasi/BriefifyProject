import 'dart:convert';

import 'package:briefify/data/constants.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/urls.dart';
import 'package:briefify/helpers/snack_helper.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/textfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WithDrawpopUp extends StatefulWidget {
  final String amount;
  const WithDrawpopUp({Key? key, required this.amount}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LogoutOverlayState();
}

class LogoutOverlayState extends State<WithDrawpopUp>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  final TextEditingController amountController = TextEditingController();
  var Selectedamount,balanceamount;
  // bool _loading = true;
  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return
      // _loading == true
      //   ? const Center(child: CircularProgressIndicator())
      //   :
      Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(15.0),
              height: 180.0,

              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          textAlignVertical: TextAlignVertical.bottom,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: inputField1(
                            label1: 'Enter Amount',
                            context: context,
                            prefixicon: const Icon(
                              CupertinoIcons.money_dollar,
                              color: basiccolor,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                  ),
                  Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ButtonTheme(
                                height: 35.0,
                                minWidth: 110.0,
                                child: MaterialButton(
                                  color: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  splashColor: Colors.white.withAlpha(40),
                                  child: const Text(
                                    'Cancel',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      Navigator.pop(context);
                                    });
                                  },
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                            child:  ButtonTheme(
                                height: 35.0,
                                minWidth: 110.0,
                                child: MaterialButton(
                                  color: basiccolor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  splashColor: Colors.white.withAlpha(40),
                                  child: const Text(
                                    'Request',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                  onPressed: () {
                                    print('Request');
                                    print(amountController.text);
                                    print(widget.amount);
                                    Selectedamount = int.parse(amountController.text.toString());
                                    var a = widget.amount.toString().substring(0,(widget.amount.length)-3);
                                    balanceamount = int.parse(a);
                                    print(balanceamount);
                                    print(Selectedamount);
                                    if(balanceamount<5 || Selectedamount<5){
                                      SnackBarHelper.showSnackBarWithoutAction(context,
                                          message: 'Minimum \$5 can be withdraw');
                                    }
                                      else if (balanceamount<Selectedamount) {
                                        SnackBarHelper.showSnackBarWithoutAction(context,
                                          message: 'You can withdraw maximum \$'+balanceamount.toString(),);
                                      }
                                      else {
                                        Withdrawfunction();
                                      }
                                  },
                                )
                            ),
                          ),
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
  }
  Future<String> Withdrawfunction() async {
    var formData = FormData.fromMap({
      'price': Selectedamount,
    });
    // setState(() {
    //   _loading = true;
    // });
    final String apiToken = await Prefs().getApiToken();
    print(apiToken);
    // const String apiToken =
    //     'xn1u2JPvXGmXn3pEg5Tm00JAdtJLp44cMFTQh9otjtA7Hu2OV0KTkCkzxBir';
    Response sr;
    Dio dio = Dio();
    try {
      sr = await dio.post(uRequestMoneyUser,
          options: Options(headers: {"Authorization": "Bearer $apiToken"}),
        data: formData,
      );
      var resp = jsonDecode(jsonEncode(sr.data).toString());
      print(resp);
      Navigator.pushNamed(context, walletRoute);
      // setState(() {
      //   _loading = false;
      // });
    } catch (e) {
      // setState(() {
      //   _loading = false;
      // });
      // print(e);
    }
    return '';
  }
}