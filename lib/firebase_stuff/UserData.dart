import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData{
  static UserData? _currentLoggedInUser;
  static UserData? get currentLoggedInUser => _currentLoggedInUser;
  late String email;
  late String uid;
  late String username;
  late String photoURL;

  UserData({required this.uid}) {
      setUser();
  }

  static Future<bool> initLoggedInUser() async {
    _currentLoggedInUser =
      UserData(uid: FirebaseAuth.instance.currentUser!.uid);
    await _currentLoggedInUser!.setUser();
    return true;
  }

  setUser() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if(snap.data() == null){
      return;
    }
    Map<String, dynamic> asMap = (snap.data() as Map<String, dynamic>);

    email = asMap["email"];
    username = asMap["username"];
    photoURL = asMap["photoURL"];
  }
}