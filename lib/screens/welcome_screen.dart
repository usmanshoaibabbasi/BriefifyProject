import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/screens/term_and_condition.dart';
import 'package:briefify/widgets/button_one.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool agree = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffbfbfb),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 5, child: Image.asset(gifLogo)),
          const Expanded(
              flex: 1,
              child: Text(
                'Welcome to Briefify',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              )),
          const Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Text(
                  'Knowledge Simplified for all',
                  style: TextStyle(
                    color: kTextColorLightGrey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              )),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: basiccolor),
                        onPressed: agree
                            ? () {
                                Navigator.pushNamed(
                                  context,
                                  registerRoute,
                                );
                              }
                            : null,
                      child: Text(
                        "Create account".toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: basiccolor),
                        onPressed: () {
                          Navigator.pushNamed(context, loginRoute);
                        },
                      child: Text(
                        "Login to Briefify".toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),
                      )),
                ),
                // ButtonOne(
                //   onPressed: () {
                //     Navigator.pushNamed(context, loginRoute);
                //   },
                //   title: 'Login to Briefify',
                //   minSize: 30,
                // ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      child: Checkbox(
                        autofocus: true,
                        value: agree,
                        onChanged: (value) {
                          setState(() {
                            agree = value ?? false;
                          });
                        },
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'I agree with',
                          overflow: TextOverflow.ellipsis,
                        ),
                        GestureDetector(
                          onTap: (() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TermAndConditionScreen()),
                            );
                          }),
                          child: Container(
                            child: Text(
                              ' terms & conditions',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 20,
            ),
          ),
          // Expanded(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       const Text(
          //         'Have an account already? ',
          //         style: TextStyle(
          //           color: kTextColorLightGrey,
          //         ),
          //       ),
          //       TextButton(
          //         onPressed: () {
          //           Navigator.pushNamed(context, loginRoute);
          //         },
          //         child: const Text('Login to Briefify'),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
