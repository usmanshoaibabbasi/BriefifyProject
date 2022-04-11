import 'package:flutter/material.dart';

const kPrimaryColorLight = Color(0xFF1a99f6);
const CheckBoxDisableColor = Color(0x34D3D3D3);
const kPrimaryColorDark = Color(0xff1165a3);
const kSecondaryColorLight = Color(0xFF1d2d4c);
const kSecondaryColorDark = Color(0xFF202843);
const kSearchFieldBG = Color(0xFFe9e8e9);
const kTextColorLightGrey = Color(0xFF8a8c9d);
const kPrimaryTextColor = Color(0xFF212121);
const kSecondaryTextColor = Color(0xFF757575);
const basiccolor = Color(0xFF202843);

const typePDF = 'PDF';
const typeArticle = 'Article';
const typeVideo = 'Video';

const API_TOKEN = 'API_TOKEN';

const verificationNotSent = 'Not Sent';
const verificationApproved = 'Approved';
const verificationPending = 'Pending';
const verificationDeclined = 'Denied';

const badgeVerificationNotSent = 0;
const badgeVerificationPending = 1;
const badgeVerificationApproved = 2;
const badgeVerificationDenied = 3;


class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "a7d8de" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}