import 'package:briefify/helpers/colors.dart';
import 'package:flutter/material.dart';

InputDecoration inputField1(
    {required String label1 ,
      BuildContext? context,
      Widget? suffixIcon,
      Widget? prefixicon}) {
  return InputDecoration(
    alignLabelWithHint: true,
    contentPadding: const EdgeInsets.fromLTRB(15, 19, 10, 19),
    errorStyle: const TextStyle(),
    prefixIcon: prefixicon,
    suffixIcon: suffixIcon,

    focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(
          color: basiccolor,
        )),
    errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(
          color: basiccolor,
        )),
    enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(
          color: basiccolor,
        )),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: basiccolor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12.0))),
    fillColor: Colors.white,
    filled: true,
    labelStyle: TextStyle(
      color: HexColor('#bbb'),
      height: 1,
    ),
    label: Text(
      label1,
      style: TextStyle(
        color: basiccolor,
      ),
    ),
  );
}
