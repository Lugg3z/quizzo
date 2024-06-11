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
  List<StatefulWidget>? quizNames;

  @override
  void initState() {
    super.initState();
    fetchQuizNames();
  }

  Future<void> fetchQuizNames() async {
    List<StatefulWidget> names = await getInstancesByAuthor();
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
            children: [
              const SizedBox(
                height: 15,
              ),
              quizNames == null
                  ? const CircularProgressIndicator()
                  : ListView.builder(
                shrinkWrap:
                    true,
                itemCount: quizNames!.length,
                itemBuilder: (context, index) {
                  return ListTile(title: quizNames![index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
