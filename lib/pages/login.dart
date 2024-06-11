import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzo/provider/userLoggedInProvider.dart';
import 'main.dart';
import 'register.dart';
import '../constants/colors.dart';
import '../widgets/inputfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isloading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> login() async {
    setState(() {
      isloading = true;
    });
    String mail = _emailController.text;
    String password = _passwordController.text;
    String response = await AuthMethods.login(mail, password);
    setState(() {
      isloading = false;
    });
    if (response != "ok") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This combination of email and password could not be found!"),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserCredentialChanged>(
        builder: (context, value, child) => Scaffold(
              backgroundColor: AppColor.secondaryColor,
              body: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Quizzo",
                          style: TextStyle(
                              fontFamily: "Rubik",
                              fontSize: 30,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 15),
                      //email
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 430.0,
                        ),
                        child: TextInput(
                          hintText: "e-mail",
                          inputType: TextInputType.emailAddress,
                          controller: _emailController,
                          fillColor: AppColor.mainColor,
                        ),
                      ),
                      const SizedBox(height: 15),

                      //passwort
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 430.0,
                        ),
                        child: TextInput(
                          hintText: "password",
                          inputType: TextInputType.text,
                          controller: _passwordController,
                          fillColor: AppColor.mainColor,
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
                          onTap: () async {
                            await login();
                            value.userDataChanged();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const ShapeDecoration(
                                color: AppColor.mainColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)))),
                            child: !isloading
                                ? const Text(
                                    style:
                                        TextStyle(color: AppColor.thirdColor),
                                    "Log in")
                                : const Center(
                                    child: CircularProgressIndicator(),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account yet?",
                        style: TextStyle(color: AppColor.thirdColor)),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()),
                      ),
                      child: const Text(
                        " Register!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainColor),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
