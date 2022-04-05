import 'package:flutter/material.dart';

import 'constants.dart';

final kAuthInputDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(0.0),
    borderSide: const BorderSide(color: Colors.grey),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(0.0),
    borderSide: const BorderSide(color: Colors.grey),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(0.0),
    borderSide: const BorderSide(color: Colors.grey),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(0.0),
    borderSide: const BorderSide(color: Colors.white),
  ),
  labelStyle: const TextStyle(color: Colors.grey),
  hintStyle: const TextStyle(
    color: Colors.grey,
  ),
  filled: true,
  fillColor: Colors.white,
);

final kPostInputDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: kPrimaryColorLight),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: kPrimaryColorLight),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: kPrimaryColorLight),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(color: kPrimaryColorLight),
  ),
  labelStyle: const TextStyle(color: kPrimaryColorLight),
  hintStyle: const TextStyle(
    color: Colors.grey,
  ),
  filled: true,
  fillColor: Colors.white,
);

final kSearchInputDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(color: kSearchFieldBG),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(color: kSearchFieldBG),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(color: kSearchFieldBG),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide: const BorderSide(color: kSearchFieldBG),
  ),
  labelStyle: const TextStyle(color: kPrimaryTextColor),
  hintStyle: const TextStyle(
    color: Colors.grey,
  ),
  filled: true,
  fillColor: kSearchFieldBG,
);
