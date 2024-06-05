import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzo/widgets/appbar.dart';
import 'package:quizzo/widgets/navbar.dart';



class MyQuizzes extends StatefulWidget {
  const MyQuizzes({super.key});
  @override
  State<MyQuizzes> createState() => _MyQuizzesState();
}

class _MyQuizzesState extends State<MyQuizzes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavBar(),
        appBar: CustomAppBar(),
        resizeToAvoidBottomInset: false,
        body: const SingleChildScrollView(
          child: Center(
            child: Column(
              
            )
          )
        )
    );
  }
}