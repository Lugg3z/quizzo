import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzo/UserData.dart';
import 'package:quizzo/appbar.dart';
import 'package:quizzo/constants/colors.dart';
import 'package:quizzo/create_card.dart';
import 'package:quizzo/inputfield.dart';
import 'package:quizzo/main.dart';
import 'package:quizzo/navbar.dart';

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
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              const SizedBox(height: 30),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 430.0,
                ),
                child: TextInput(
                  fillColor: AppColor.mainColor,
                  hintText: "name of quiz",
                  inputType: TextInputType.emailAddress,
                  controller: _nameOfQuiz,
                ),
              ),
              const SizedBox(height: 30),
              Column(children: cards),
              ConstrainedBox(
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
                        child: const Icon(Icons.add))),
              ),
              const SizedBox(height: 30),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 100.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    //firebase hochladen usw
                    uploadQuiz();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                        color: AppColor.mainColor,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: !loading
                        ? const Text(
                            'Upload Quiz',
                            style: TextStyle(color: AppColor.thirdColor),
                          )
                        : const CircularProgressIndicator(
                            color: AppColor.thirdColor,
                          ),
                  ),
                ),
              )
            ]),
          ),
        ));
  }

  final TextEditingController _nameOfQuiz = TextEditingController();

  void uploadQuiz() async{
    List<String> terms = <String>[];
    List<String> definitions = <String>[];

    for(int i = 0; i < cards.length; i++){
      terms.add(cards[i].getTerm());
      definitions.add(cards[i].getDefinition());
    }

    print(terms);
    print(definitions);
    print(_nameOfQuiz.text);
    print(UserData.currentLoggedInUser!.username);

    await FirebaseFirestore.instance.collection('quizzes').doc(UserData.currentLoggedInUser!.username+_nameOfQuiz.text).set({"terms":terms, "definitions": definitions});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: "Quizzo",)),
      );
  }
}
