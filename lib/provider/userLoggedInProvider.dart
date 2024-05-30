import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class UserCredentialChanged extends ChangeNotifier{
  static late String _name;
  static late String _email;
  static late Image _image;
  static late bool _loggedIn;

  String get name => _name;
  String get email => _email;
  Image get image => _image;
  bool get loggedIn => _loggedIn;

  void userDataChanged() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    if(user == null){
      return;
    }
    final uid = user.uid;
    DocumentReference userRef = firestore.collection('users').doc(uid);
    DocumentSnapshot snap = await userRef.get();
    _name = (snap.data() as Map<String, dynamic>)['username'];
    _email = (snap.data() as Map<String, dynamic>)['email'];
    _image = Image.network((snap.data() as Map<String, dynamic>)['photoURL']);
    _loggedIn = true;
    notifyListeners();
  }

  void init(){
    _name = "not logged in";
    _email="-";
    _image= Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjJfzIM7lgs_uPoVT6qqextiU2E7hHBqmUAMciGe_Iig&s");
    _loggedIn=false;
  }
}