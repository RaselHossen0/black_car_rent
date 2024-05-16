import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_car/services/firebase_auth_methods.dart';
import 'package:rent_a_car/widgets/custom_textfield.dart';

import '../res/Assets/image_assets.dart';

class EmailPasswordSignup extends StatefulWidget {
  static String routeName = '/signup-email-password';
  const EmailPasswordSignup({Key? key}) : super(key: key);

  @override
  _EmailPasswordSignupState createState() => _EmailPasswordSignupState();
}

class _EmailPasswordSignupState extends State<EmailPasswordSignup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness:
          Brightness.dark, // Brightness of status bar icons
    ));
  }

  void signUpUser() async {
    context.read<FirebaseAuthMethods>().signUpWithEmail(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
          phone: phoneController.text,
          context: context,
        );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Image.asset(
            ImageAssets.signUp,
            height: MediaQuery.sizeOf(context).height / 3.8,
          ),
          const Text(
            "Create an account",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: nameController,
              hintText: 'Enter your name',
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: emailController,
              hintText: 'Enter your email',
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: phoneController,
              hintText: 'Enter your phone number',
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              controller: passwordController,
              hintText: 'Enter your password',
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: signUpUser,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey[850]),
              minimumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width / 2.5, 50),
              ),
            ),
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          //show login button
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Already have an account? Login",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
