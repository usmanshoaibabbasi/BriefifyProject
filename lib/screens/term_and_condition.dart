import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/constants.dart';
import '../data/routes.dart';
import '../widgets/button_one.dart';

class TermAndConditionScreen extends StatefulWidget {
  const TermAndConditionScreen({Key? key}) : super(key: key);

  @override
  _TermAndConditionScreenState createState() => _TermAndConditionScreenState();
}

class _TermAndConditionScreenState extends State<TermAndConditionScreen> {
  bool agree = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfffbfbfb),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 30, 0, 15),
                      child: const Text(
                        'End-User License & Agreement',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: const Text(
                              'End-User License Agreement (EULA) of BRIEFIFY',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Text(
                            'This End-User License Agreement ("EULA") is a legal agreement between you and BRIEFIFY INC. Our EULA was created by EULA Template for BRIEFIFY.\n\n'
                            'This EULA agreement governs your acquisition and use of BRIEFIFY software ("Mobile App") directly from BRIEFIFY INC or indirectly through a BRIEFIFY INC authorized reseller or distributor (a "Reseller").\n\n'
                            'Please read this EULA agreement carefully before completing the installation process and using the BRIEFIFY software. It provides a license to use the BRIEFIFY software and contains warranty information and liability disclaimers.\n\n'
                            'If you register for a free trial of the BRIEFIFY software, this EULA agreement will also govern that trial. By clicking "accept" or installing and/or using the BRIEFIFY software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.\n\n'
                            'If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.\n\n'
                            'This EULA agreement shall apply only to the Software provided by BRIEFIFY INC herewith regardless of whether other software is referred to or described herein. The terms also apply to any BRIEFIFY INC updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply.\n\n'
                            '',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: const Text(
                              'License Grant',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Text(
                            'BRIEFIFY INC hereby grants you a personal, non-transferable, non-exclusive license to use the BRIEFIFY software on your devices in accordance with the terms of this EULA agreement.\n\n'
                            'You are permitted to load the BRIEFIFY software (for example a PC, laptop, mobile or tablet) under your control. You are responsible for ensuring your device meets the minimum requirements of the BRIEFIFY software.\n\n',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: const Text(
                              'You are not permitted to:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Text(
                            'Edit, alter, modify, adapt, translate or otherwise change the whole or any part of the Software nor permit the whole or any part of the Software to be combined with or become incorporated in any other software, nor decompile, disassemble or reverse engineer the Software or attempt to do any such things.\n\n'
                            'Reproduce, copy, distribute, resell or otherwise use the Software for any commercial purpose\n\n'
                            'Allow any third party to use the Software on behalf of or for the benefit of any third party\n\n'
                            'Use the Software in any way which breaches any applicable local, national or international law\n\n'
                            'Use the Software for any purpose that BRIEFIFY INC considers is a breach of this EULA agreement\n\n',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: const Text(
                              'Intellectual Property and Ownership',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Text(
                            'BRIEFIFY INC shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of BRIEFIFY INC.\n\n'
                            'BRIEFIFY INC reserves the right to grant licenses to use the Software to third parties.\n\n',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: const Text(
                              'Termination',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Text(
                            'This EULA agreement is effective from the date you first use the Software and shall continue until terminated. You may terminate it at any time upon written notice to BRIEFIFY INC.\n\n'
                            'It will also terminate immediately if you fail to comply with any term of this EULA agreement. Upon such termination, the licenses granted by this EULA agreement will immediately terminate and you agree to stop all access and use of the Software. The provisions that by their nature continue and survive will survive any termination of this EULA agreement.\n\n',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: const Text(
                              'Governing Law',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Text(
                            'This EULA agreement, and any dispute arising out of or in connection with this EULA agreement, shall be governed by and construed in accordance with the laws of us.\n\n',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
