import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_car/services/firebase_auth_methods.dart';
import 'package:rent_a_car/widgets/custom_button.dart';
import 'package:rent_a_car/widgets/custom_textfield.dart';

import '../res/Assets/image_assets.dart';

class PhoneScreen extends StatefulWidget {
  static String routeName = '/phone';
  const PhoneScreen({Key? key}) : super(key: key);

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.14),
            Image.asset(
              ImageAssets.otp,
              height: MediaQuery.sizeOf(context).height / 2.8,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomTextField(
                controller: phoneController,
                hintText: 'Enter phone number',
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomButton(
                onTap: () {
                  context
                      .read<FirebaseAuthMethods>()
                      .phoneSignIn(context, phoneController.text);
                },
                text: 'OK',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
