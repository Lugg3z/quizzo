import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzo/firebase_stuff/UserData.dart';
import 'package:quizzo/firebase_stuff/firebase_options.dart';
import 'package:quizzo/pages/login.dart';
import 'package:quizzo/pages/searchbar.dart';
import 'provider/userLoggedInProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(create: (context) => UserCredentialChanged(), child: const MyApp()));


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    UserCredentialChanged c = UserCredentialChanged();
    c.init();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => c,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quizzo',
        theme: ThemeData(
          fontFamily: 'Rubik',
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.connectionState != ConnectionState.active) {
              return const Center(child: CircularProgressIndicator());
            }
            final user = snapshot.data;
            if (user == null) {
              return const Login();
            }
            return FutureBuilder(
              future: UserData.initLoggedInUser(),
              builder: (context2, valid) {
                if (valid.connectionState != ConnectionState.waiting) {
                  return const MyHomePage(title: "Quizzo");
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const SearchPage();
  }
}
