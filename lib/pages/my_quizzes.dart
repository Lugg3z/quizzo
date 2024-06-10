import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzo/firebase_stuff/get_quizzes.dart';
import 'package:quizzo/widgets/appbar.dart';
import 'package:quizzo/widgets/navbar.dart';



class MyQuizzes extends StatefulWidget {
  const MyQuizzes({super.key});
  @override
  State<MyQuizzes> createState() => _MyQuizzesState();
}

class _MyQuizzesState extends State<MyQuizzes> {
  late List<StatelessWidget> quizNames;
  
  @override
  void initState() {
    super.initState();
    fetchQuizNames();
  }

  Future<void> fetchQuizNames() async {
    List<StatelessWidget> names = await getInstancesByAuthor();
    setState(() {
      quizNames = names;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavBar(),
        appBar: CustomAppBar(),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: quizNames,
            )
          )
        )
    );
  }
}