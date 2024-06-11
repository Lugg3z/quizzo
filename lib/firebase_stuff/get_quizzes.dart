import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzo/constants/colors.dart';
import 'package:quizzo/firebase_stuff/UserData.dart';
import 'package:quizzo/pages/quiz.dart';

class QuizzoCard extends StatefulWidget {
  final String term;
  final String definition;
  late String display;
  QuizzoCard(this.term, this.definition, {super.key}) {
    display = term;
  }

  @override
  State<QuizzoCard> createState() => _QuizzoCardState();
}

class _QuizzoCardState extends State<QuizzoCard> {
  void onTapChangeState() {
    setState(() {
      if (widget.display == widget.term) {
        widget.display = widget.definition;
      } else {
        widget.display = widget.term;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.display = widget.term;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: onTapChangeState,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Ink(
          width: MediaQuery.of(context).size.width - 50,
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
              color: AppColor.mainColor,
              borderRadius: BorderRadius.circular(4.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 1,
                  blurRadius: 1,
                  blurStyle: BlurStyle.outer,
                )
              ]),
          child: Center(
            child: SingleChildScrollView(
              child: Text(
                widget.display,
                style: const TextStyle(color: AppColor.thirdColor, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<QuizzoCard>> getQuizByName(String uid, String name) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  QuerySnapshot querySnapshot = await firestore
      .collection('quizzes')
      .where('uid', isEqualTo: uid)
      .where('name', isEqualTo: name)
      .get();

  List<QuizzoCard> cards = [];

  QueryDocumentSnapshot doc = querySnapshot.docs[0];
  for (var i = 0; i < doc["definitions"].length; i++) {
    cards.add(QuizzoCard(doc["terms"][i], doc["definitions"][i]));
  }
  return cards;
}

Future<List<QuizNames>> getInstancesByAuthor() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot querySnapshot = await firestore
      .collection('quizzes')
      .where('uid', isEqualTo: UserData.currentLoggedInUser!.uid)
      .get();

  List<QuizNames> quizzesList = [];

  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    quizzesList.add(QuizNames(doc["name"], doc["author"], doc["uid"]));
  }

  return quizzesList;
}

class QuizNames extends StatefulWidget {
  final String name;
  final String author;
  final String uid;
  const QuizNames(this.name, this.author, this.uid, {super.key});

  @override
  State<QuizNames> createState() => _QuizNamesState();
}

class _QuizNamesState extends State<QuizNames> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Quiz(widget.uid, widget.name))),
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          child: Ink(
            width: MediaQuery.of(context).size.width - 50,
            height: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColor.mainColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 1,
                    blurRadius: 1,
                    blurStyle: BlurStyle.outer,
                  )
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                  overflow:  TextOverflow.ellipsis,
                ),
                Text(
                  "Made by: ${widget.author}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
    ]);
  }
}

/*child: Container(
            width: MediaQuery.of(context).size.width - 50,
            height: 70,
            constraints: const BoxConstraints(maxWidth: 600),
            decoration: BoxDecoration(
                color: AppColor.mainColor,
                borderRadius: BorderRadius.circular(4.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              */
