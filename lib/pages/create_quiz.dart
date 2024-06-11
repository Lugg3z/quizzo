import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizzo/firebase_stuff/UserData.dart';
import 'package:quizzo/widgets/appbar.dart';
import 'package:quizzo/constants/colors.dart';
import 'package:quizzo/widgets/create_card.dart';
import 'package:quizzo/widgets/inputfield.dart';
import '../main.dart';
import 'package:quizzo/widgets/navbar.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({super.key});

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  bool loading = false;
  List<createCard> cards = <createCard>[createCard(), createCard()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 430
                ),
                width: MediaQuery.of(context).size.width - 50,
                child: TextInput(
                  fillColor: AppColor.mainColor,
                  hintText: "name of quiz",
                  inputType: TextInputType.emailAddress,
                  controller: _nameOfQuiz,
                ),
              ),
              const SizedBox(height: 30),
              ListView.builder(
                shrinkWrap:
                    true,
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return ListTile(title: cards[index]);
                },
              ),

              Container(
                constraints: const BoxConstraints(
                  maxWidth: 50.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      cards.add(createCard());
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 100.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    uploadQuiz();
                  },
                  child: Container(
                    width: 100,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: !loading
                        ? const Text(
                            'Upload Quiz',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColor.thirdColor),
                          )
                        : const CircularProgressIndicator(
                            color: AppColor.thirdColor,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final TextEditingController _nameOfQuiz = TextEditingController();

  void uploadQuiz() async {
    List<String> terms = <String>[];
    List<String> definitions = <String>[];

    for (int i = 0; i < cards.length; i++) {
      terms.add(cards[i].getTerm());
      definitions.add(cards[i].getDefinition());
    }

    String nameInDataBase =
        UserData.currentLoggedInUser!.uid + _nameOfQuiz.text;

    await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(nameInDataBase)
        .set({
      "terms": terms,
      "definitions": definitions,
      "name": _nameOfQuiz.text,
      "author": UserData.currentLoggedInUser!.username,
      "uid": UserData.currentLoggedInUser!.uid
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const MyHomePage(
                title: "Quizzo",
              )),
    );
  }
}
