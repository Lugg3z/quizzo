import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzo/constants/colors.dart';
import 'package:quizzo/pages/create_quiz.dart';
import 'package:quizzo/pages/my_quizzes.dart';
import 'package:quizzo/pages/searchbar.dart';
import 'package:quizzo/provider/userLoggedInProvider.dart';
import '../pages/login.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String name = "name";
  String email = "email";

  @override
  Widget build(BuildContext context) {
    return Consumer<UserCredentialChanged>(
        builder: (context, value, child) => Drawer(
            backgroundColor: AppColor.secondaryColor,
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: GestureDetector(
                    child: Text(
                      value.name, //firebase
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        color: AppColor.secondaryColor,
                      ),
                    ),
                  ),
                  accountEmail: Text(
                    value.email, //firebase
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      color: AppColor.secondaryColor,
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(value.imageUrl),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/blackImage.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.search,
                    color: AppColor.mainColor,
                  ),
                  title: const Text(
                    'Search',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      color: AppColor.thirdColor,
                    ),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage())),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.my_library_books,
                    color: AppColor.mainColor,
                  ),
                  title: const Text(
                    'My Quizzes',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      color: AppColor.thirdColor,
                    ),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MyQuizzes())), // To Favorite Page
                ),
                ListTile(
                  leading: const Icon(
                    Icons.create,
                    color: AppColor.mainColor,
                  ),
                  title: const Text(
                    'Create Quiz',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      color: AppColor.thirdColor,
                    ),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateQuiz())),
                ),
                const Divider(),
                /*ListTile(                       login button - not needed
                  leading: const Icon(
                    Icons.login,
                    color: AppColor.mainColor,
                  ),
                  title: const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      color: AppColor.thirdColor,
                    ),
                  ),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login())),
                ),
                */
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: AppColor.mainColor,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      color: AppColor.thirdColor,
                    ),
                  ),
                  onTap: () async {
                    await value.logout(); // Call the logout function
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                ),
              ],
            )));
  }
}
