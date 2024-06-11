import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {

  @override
  final Size preferredSize =  const Size.fromHeight(56.0);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'Quizzo',
        style: TextStyle(
          color: AppColor.thirdColor, 
          fontSize: 25,
          fontWeight: FontWeight.w600,
          fontFamily: "Rubik"
        ),
      ),
      backgroundColor: AppColor.mainColor,
    );
}}