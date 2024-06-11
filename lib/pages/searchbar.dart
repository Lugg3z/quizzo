import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizzo/constants/colors.dart';
import 'package:quizzo/firebase_stuff/get_quizzes.dart';
import 'package:quizzo/widgets/appbar.dart';
import 'package:quizzo/widgets/inputfield.dart';
import 'package:quizzo/widgets/navbar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();
  String _searchText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Container(
            color: AppColor.secondaryColor,
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                width: MediaQuery.of(context).size.width - 50,
                height: 45,
                child: TextInput(
                  controller: _controller,
                  hintText: "Search",
                  inputType: TextInputType.text,
                  fillColor: AppColor.secondaryColor,
                  onChanged: (text) {
                    setState(() {
                      _searchText = text;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
            ]),
          ),
          const SizedBox(
            height: 15,
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: getStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: Text("Could not find any Quizzes"));
                }

                final quizzes = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: QuizNames(quizzes[index]["name"],
                          quizzes[index]["author"], quizzes[index]["uid"]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStream() {
    return _firestore
        .collection('quizzes')
        .where('name', isGreaterThanOrEqualTo: _searchText)
        .where('name', isLessThanOrEqualTo: '${_searchText}z')
        .snapshots();
  }
}
