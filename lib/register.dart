import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'constants/colors.dart';
import 'inputfield.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<Register> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _beschreibungController = TextEditingController();
  final _usernameController = TextEditingController();
  Uint8List? _image;

  bool loading = false;
  String errorMessage = "";
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _beschreibungController.dispose();
  }

  selectImage(ImageSource src) async {
    final ImagePicker pick = ImagePicker();
    XFile? file = await pick.pickImage(source: src);
    if (file != null) {
      return await file.readAsBytes();
    }
  }

  void chooseImageFromGallery() async {
    Uint8List img = await selectImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void register() async {
    String response;
    if (_image != null) {
      setState(() {
        loading = true;
      });
      response = await AuthMethods.createNewUser(
          email: _emailController.text,
          password: _passwordController.text,
          username: _usernameController.text,
          file: _image!);
    } else {
      response = "Choose a picture!";
    }

    setState(() {
      loading = false;
    });

    if (response == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.secondaryColor,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Quizzo",
                    style: TextStyle(
                        fontFamily: "Rubik",
                        fontSize: 30,
                        fontWeight: FontWeight.w700)),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                    borderRadius: BorderRadius.circular(64),
                    onTap: () {
                      chooseImageFromGallery();
                    },
                    child: _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: Image.asset(
                                    'images/placeholder.png',
                                    fit: BoxFit.fill)
                                .image,
                          )),

                const SizedBox(height: 15),

                //username
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 430.0,
                  ),
                  child: TextInput(
                    fillColor: AppColor.mainColor,
                    hintText: "username",
                    inputType: TextInputType.text,
                    controller: _usernameController,
                  ),
                ),
                const SizedBox(height: 15),

                //email
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 430.0,
                  ),
                  child: TextInput(
                    fillColor: AppColor.mainColor,
                    hintText: "e-mail",
                    inputType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                ),
                const SizedBox(height: 15),

                //passwort
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 430.0,
                  ),
                  child: TextInput(
                    fillColor: AppColor.mainColor,
                    hintText: "password",
                    inputType: TextInputType.text,
                    controller: _passwordController,
                    isPassword: true,
                  ),
                ),
                const SizedBox(height: 15),
                //Login button
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 100.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      register();
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
                              'Register',
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
        bottomNavigationBar: BottomAppBar(
          color: AppColor.secondaryColor,
          elevation: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("You already have an account? ",
                  style: TextStyle(color: AppColor.thirdColor)),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                ),
                child: const Text(
                  " Log in!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColor.mainColor),
                ),
              )
            ],
          ),
        ));
  }
}

class AuthMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _userCollectionName = "users";

  static Future<String> uploadProfilePicture(Uint8List img) async {
    const String folderName = "profilePictures";

    Reference ref = FirebaseStorage.instance
        .ref()
        .child(folderName)
        .child(_auth.currentUser!.uid);
    UploadTask task = ref.putData(img);
    TaskSnapshot sn = await task;

    String url = await sn.ref.getDownloadURL();

    return url;
  }

  static Future<String> createNewUser(
      {required String email,
      required String password,
      required String username,
      required Uint8List file}) async {
    try {
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        return "Fields mustn't be empty!";
      }
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String userID = user.user!.uid;

      String url = await uploadProfilePicture(file);

      await _firestore.collection(_userCollectionName).doc(userID).set({
        'username': username,
        'uid': userID,
        'email': email,
        'photoURL': url,
        'password': password
      });

      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> login(String mail, String password) async {
    try {
      if (mail.isEmpty || password.isEmpty) return "Fill out every field!";
      await _auth.signInWithEmailAndPassword(email: mail, password: password);
      return "ok";
    } catch (e) {
      return e.toString();
    }
  }
}
