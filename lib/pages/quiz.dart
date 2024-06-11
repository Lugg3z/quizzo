import 'package:flutter/material.dart';
import 'package:quizzo/constants/colors.dart';
import 'package:quizzo/firebase_stuff/get_quizzes.dart';
import 'package:quizzo/widgets/appbar.dart';
import 'package:quizzo/widgets/navbar.dart';

class Quiz extends StatefulWidget {
  late String uid;
  late String name;
  Quiz(this.uid, this.name, {super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late List<QuizzoCard> quiz;
  late int iterator;
  late QuizzoCard currentCard;
  bool isQuizLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchQuizNames();
    iterator = 0;
  }

  Future<void> fetchQuizNames() async {
    List<QuizzoCard> tempQuiz = await getQuizByName(widget.uid, widget.name);
    setState(() {
      quiz = tempQuiz;
      currentCard = quiz[iterator];
      isQuizLoaded = true;
    });
  }

  void iteratorAdd(int toAdd) {
    if (iterator + toAdd >= 0 && iterator + toAdd < quiz.length) {
      iterator += toAdd;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: CustomAppBar(),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: isQuizLoaded
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  quiz[iterator],
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: AppColor.standardShadow),
                        child: Material(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColor.mainColor,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4),
                            onTap: () {
                              setState(() {
                                iteratorAdd(-1);
                              });
                            },
                            child: const Icon(
                              Icons.keyboard_arrow_left_outlined,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: AppColor.standardShadow),
                        child: Material(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColor.mainColor,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4),
                            onTap: () {
                              setState(() {
                                iteratorAdd(1);
                              });
                            },
                            child: const Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
