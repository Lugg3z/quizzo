import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppColor {
  AppColor._();
  static const Color mainColor = Color.fromARGB(255, 248, 152, 255);
  static const Color thirdColor = Color.fromARGB(255, 0, 0, 0);
  static const Color secondaryColor = Color.fromARGB(255, 255, 255, 255);
  static const Color darkerMain = Color(0xffcc6fd3);

  static List<BoxShadow> standardShadow = [
    const BoxShadow(
      color: Colors.black,
      spreadRadius: 1,
      blurRadius: 1,
      blurStyle: BlurStyle.outer,
    )
  ];
}
