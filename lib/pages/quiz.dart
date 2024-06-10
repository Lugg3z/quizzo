import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: CustomAppBar(),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: isQuizLoaded ? Column(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500.0,
                maxHeight: 200,
              ),
              child: quiz[iterator]
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Iterator: $iterator',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          iterator++;
                        });
                      },
                      icon: Icon(Icons.arrow_left),
                      label: Text('Increment'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.blue, // Text color
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ) : CircularProgressIndicator(),
      ),
    );
  }
}
