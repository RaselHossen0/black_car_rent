import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rent_a_car/screens/signup_email_password_screen.dart';

import '../Utils/showSnackbar.dart';
import '../res/Assets/image_assets.dart';
import '../services/firebase_auth_methods.dart';
import 'login_email_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      // statusBarColor: Colors.black, // Background color of the status bar
      statusBarIconBrightness:
          Brightness.dark, // Brightness of status bar icons
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                ImageAssets.signIn,
                height: MediaQuery.sizeOf(context).height / 2.8,
              ),
              const Text(
                "Welcome to  Black Rent Car",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 27),
              ),
              const SizedBox(
                height: 20,
              ),
              // CustomField(
              //     controller: email1,
              //     hint: "Email",
              //     iconData: Icons.email_outlined),
              const SizedBox(
                height: 10,
              ),
              // CustomField(
              //     controller: email,
              //     hint: "Phone Number",
              //     iconData: Icons.phone_iphone_rounded),
              const SizedBox(
                height: 20,
              ),
              // CustomField(
              //     controller: password,
              //     hint: "Password",
              //     iconData: Icons.lock_outlined),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    FirebaseAuth _auth = FirebaseAuth.instance;
                    TextEditingController emailController =
                        TextEditingController();
                    //take email as input
                    showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                              title: Text("Enter Email"),
                              content: CupertinoTextField(
                                padding: const EdgeInsets.all(10),
                                controller: emailController,
                                placeholder: "Email",
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                CupertinoDialogAction(
                                  onPressed: () {
                                    //send password reset email
                                    FirebaseAuthMethods(_auth)
                                        .sendPasswordResetEmail(
                                            emailController.text, context);
                                    showSnackBar(
                                        context, 'Password reset email sent!');
                                    Navigator.pop(context);
                                  },
                                  child: Text("Send"),
                                ),
                              ],
                            ));
                  },
                  child: Text(
                    "Forgot Password ?",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, EmailPasswordLogin.routeName);
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.pushNamed(context, PhoneScreen.routeName);
              //   },
              //   child: Container(
              //     height: 60,
              //     width: double.infinity,
              //     margin: const EdgeInsets.symmetric(horizontal: 20),
              //     decoration: BoxDecoration(
              //         color: Colors.grey[850],
              //         borderRadius: BorderRadius.circular(20)),
              //     child: const Center(
              //       child: Text(
              //         "Phone Sign In",
              //         style: TextStyle(
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold,
              //             fontSize: 16),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey.withOpacity(.2),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                  const Text(
                    "OR",
                    style: TextStyle(color: Colors.grey, fontSize: 17),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.grey.withOpacity(.2),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, EmailPasswordSignup.routeName);
                  },
                  child: RichText(
                      text: const TextSpan(children: [
                    TextSpan(
                      text: "New to the app? ",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text: " SignUp",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                  ])),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
