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
  QuizzoCard(this.term, this.definition, {super.key}) {display = term;}

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
    return GestureDetector(
      onTap: onTapChangeState,
      child: Container(
        color: AppColor.mainColor,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 600, minWidth: 800),
          child: SingleChildScrollView(
            child: Text(
              widget.display,
              style: const TextStyle(color: AppColor.secondaryColor),
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

Future<List<StatelessWidget>> getInstancesByAuthor() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  QuerySnapshot querySnapshot = await firestore
      .collection('quizzes')
      .where('uid', isEqualTo: UserData.currentLoggedInUser!.uid)
      .get();

  List<StatelessWidget> quizzesList = [];

  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    quizzesList.add(QuizNames(doc["name"], doc["author"], doc["uid"]));
  }

  return quizzesList;
}

class QuizNames extends StatelessWidget {
  final String name;
  final String author;
  final String uid;
  QuizNames(this.name, this.author, this.uid, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => Quiz(uid, name))),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 430.0,
            ),
            color: AppColor.mainColor,
            padding: const EdgeInsets.all(8.0), 
            child: Text(
              "$name Made by: $author",
              style: const TextStyle(fontSize: 20), 
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}