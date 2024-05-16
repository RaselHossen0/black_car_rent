import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Data/Netword/Firebase/firebase_services.dart';
import '../../Utils/Widget/snackbar.dart';
import '../../Utils/Widget/text_field.dart';
import '../../res/Assets/image_assets.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final GetProfileController _controller = Get.put(GetProfileController());
  final _key = GlobalKey<FormState>();
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  if (isEdit)
                    Center(
                      child: GestureDetector(
                        onTap: () => _controller.pickImage(),
                        child: Obx(() => CircleAvatar(
                              radius: 60,
                              backgroundImage: _controller.path.value.isEmpty
                                  ? AssetImage(ImageAssets.image1)
                                  : FileImage(File(_controller.path.value))
                                      as ImageProvider,
                            )),
                      ),
                    ),
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(ImageAssets.image1),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!_controller.isPress)
                    InkWell(
                      onTap: () {
                        _controller.isPress = true;
                      },
                      child: Center(
                        child: Text(
                          'Edit Profile Picture',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  if (_controller.isPress)
                    CustomField(
                      controller: _controller.nameController,
                      hint: "Full Name",
                      iconData: Icons.person_outline_rounded,
                    ),
                  const SizedBox(height: 20),
                  if (_controller.isPress)
                    CustomField(
                      controller: _controller.emailController,
                      hint: "Email",
                      iconData: Icons.email,
                    ),
                  const SizedBox(height: 20),
                  if (_controller.isPress)
                    CustomField(
                      controller: _controller.emailController,
                      hint: "Phone Number",
                      iconData: Icons.phone_iphone_rounded,
                    ),
                  const SizedBox(height: 20),
                  if (_controller.isPress)
                    GestureDetector(
                      onTap: () {
                        if (_key.currentState!.validate()) {
                          // Call update profile method
                          ShowSnackBar(
                              "Success", "Profile updated successfully");
                        }
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            "Update Profile",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      FirebaseService.signOut();
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GetProfileController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final path = RxString('');
  bool isPress = false;

  void pickImage() async {
    // Implement image picker functionality
  }
}
