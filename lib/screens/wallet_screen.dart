// ignore_for_file: avoid_unnecessary_containers

import 'dart:convert';

import 'package:briefify/data/constants.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/data/urls.dart';
import 'package:briefify/models/wallet_model.dart';
import 'package:briefify/utils/prefs.dart';
import 'package:briefify/widgets/wallet_history.dart';
import 'package:briefify/widgets/withdraw_popup.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final List<WalletModal> walletlist = [];
  late Future walletfuture;
  bool _loading = true;
  var wallet_amount;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    walletfuture = walletapifunction();
    super.initState();
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            color: Color(0XffD3D3D3),
            child: _loading == true
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: Image.asset(
                                            'assets/images/walletlayer.png',
                                            height: 280,
                                            width: MediaQuery.of(context).size.width,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('WALLET BALANCE'),
                                          Container(
                                            child: Text(
                                              '\$'+wallet_amount.toString(),
                                              style: const TextStyle(fontSize: 30),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // ignore: avoid_unnecessary_containers
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => WithDrawpopUp(
                                            amount: wallet_amount.toString(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 20),
                                              margin: const EdgeInsets.only(right: 20),
                                              decoration: BoxDecoration(
                                                color: basiccolor,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: GestureDetector(
                                                child: const Text(
                                                  "Withdraw",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,)
                                  ]),
                            ),
                            Container(
                              child: Column(children: [
                              const SizedBox(height: 20,),
                              // Container(
                              // margin: const EdgeInsets.only(top: 10, right: 25),
                              // child: Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     walletlist.isEmpty
                              //     ?
                              //     Text('View All')
                              //     :
                              //     Container(),
                              //   ],
                              // ),
                              // ),
                              FutureBuilder(
                              future: walletfuture,
                              builder:
                                  (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.data == null || snapshot.data.isEmpty) {
                                return Container(
                                    margin: const EdgeInsets.only(bottom: 20.0),
                                    child:  Center(
                                        child: Container(
                                          child: const Text('No Request Found',
                                            style: TextStyle(
                                              color: basiccolor,
                                              fontSize: 16
                                            ),
                                          ),
                                        )));
                                } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                    controller: scrollController,
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return WallletHistoryView(
                                        walletindex: snapshot.data[index],
                                      );
                                    });
                                }
                              },
                              ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 31,
                        left: 15,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, homeRoute, ModalRoute.withName(welcomeRoute));
                          },
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: basiccolor,
                                borderRadius: BorderRadius.circular(200),
                              ),
                              child: const Icon(
                                Icons.arrow_back_outlined,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }

  // Future<dynamic> walletapifunction1() async {
  //   setState(() {
  //     _loading = true;
  //   });

  //   try {
  //     Map results = await NetworkHelper().updateUserWallet();
  //     if (!results['error']) {
  //       SnackBarHelper.showSnackBarWithoutAction(context, message: 'Success');
  //     } else {
  //       SnackBarHelper.showSnackBarWithoutAction(context,
  //           message: results['errorData']);
  //     }
  //   } catch (e) {
  //     SnackBarHelper.showSnackBarWithoutAction(context, message: e.toString());
  //   }
  //   setState(() {
  //     _loading = false;
  //   });
  // }

  Future<List<WalletModal>> walletapifunction() async {
    setState(() {
      _loading = true;
    });
    final String apiToken = await Prefs().getApiToken();
    print(apiToken);
    // const String apiToken =
    //     'xn1u2JPvXGmXn3pEg5Tm00JAdtJLp44cMFTQh9otjtA7Hu2OV0KTkCkzxBir';
    Response sr;
    Dio dio = Dio();
    try {
      sr = await dio.post(uWalletUser,
          options: Options(headers: {"Authorization": "Bearer $apiToken"}));
      var resp = jsonDecode(jsonEncode(sr.data).toString());
      print(resp);
      var response = resp['requests'];
      print(response);
      wallet_amount= resp['wallet_amount'] ?? 0.0000;
      wallet_amount = wallet_amount.toStringAsFixed(4);
      for (var r in response) {
        WalletModal wallet = WalletModal(
          id: r['id'] ?? 0,
          price: r['price'] ?? 0,
          status: r['status'] ?? 0,
          user_id: r['user_id'] ?? 0,
          likesfor: r['likesfor'] ?? 0,
          created_at: r['created_at'],
          updated_at: r['updated_at'],

        );
        walletlist.add(wallet);
        print('walletlist');
        print(walletlist);
      }
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      // print(e);
    }
    return walletlist;
  }
}
