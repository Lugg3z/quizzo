import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCredentialChanged extends ChangeNotifier {
  late String _name;
  late String _email;
  late String _imageUrl;
  late bool _loggedIn;

  UserCredentialChanged() {
    init();
    userDataChanged(); // Ensure we attempt to fetch user data on initialization
  }

  String get name => _name;
  String get email => _email;
  String get imageUrl => _imageUrl;
  bool get loggedIn => _loggedIn;

  Future<void> userDataChanged() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _loggedIn = false;
      _name = "not logged in";
      _email = "-";
      _imageUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjJfzIM7lgs_uPoVT6qqextiU2E7hHBqmUAMciGe_Iig&s";
      notifyListeners();
      return;
    }

    final uid = user.uid;
    final firestore = FirebaseFirestore.instance;
    DocumentReference userRef = firestore.collection('users').doc(uid);

    try {
      DocumentSnapshot snap = await userRef.get();
      if (snap.exists && snap.data() != null) {
        final data = snap.data() as Map<String, dynamic>;
        _name = data['username'] ?? "No name";
        _email = data['email'] ?? "No email";
        _imageUrl = data['photoURL'] ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjJfzIM7lgs_uPoVT6qqextiU2E7hHBqmUAMciGe_Iig&s";
        _loggedIn = true;
      } else {
        _name = "No name";
        _email = "No email";
        _imageUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjJfzIM7lgs_uPoVT6qqextiU2E7hHBqmUAMciGe_Iig&s";
        _loggedIn = false;
      }
    } catch (e) {
      _name = "Error";
      _email = "Error";
      _imageUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjJfzIM7lgs_uPoVT6qqextiU2E7hHBqmUAMciGe_Iig&s";
      _loggedIn = false;
    }

    notifyListeners();
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    init();
    notifyListeners();
  }

  void init() {
    _name = "not logged in";
    _email = "-";
    _imageUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjJfzIM7lgs_uPoVT6qqextiU2E7hHBqmUAMciGe_Iig&s";
    _loggedIn = false;
  }
}
