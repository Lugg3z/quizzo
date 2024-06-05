import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quizzo/constants/colors.dart';
import 'package:quizzo/inputfield.dart';

class createCard extends StatelessWidget {
  createCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 430.0,
          ),
          child: TextInput(
            fillColor: AppColor.darkerMain,
            hintText: "Term",
            inputType: TextInputType.emailAddress,
            controller: _term,
          ),
        ),
        const SizedBox(height: 15),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 430.0,
          ),
          child: TextInput(
            fillColor: AppColor.darkerMain,
            hintText: "Definition",
            inputType: TextInputType.emailAddress,
            controller: _definition,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  final TextEditingController _term = TextEditingController();
  final TextEditingController _definition = TextEditingController();

  String getTerm(){
    return _term.text;
  }

  String getDefinition(){
    return _definition.text;
  }
}
