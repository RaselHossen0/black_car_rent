import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rent_a_car/View/account/login.dart';

import '../../../Getx/get_otp.dart';
import '../../../Getx/get_signup.dart';
import '../../../Utils/Widget/snackbar.dart';
import '../../../View/HomePage/home_page.dart';
import '../../../View/account/otp.dart';
import '../../../View/account/profilePage.dart';
import '../../Local/SharedPreference/shared_preference.dart';

class FirebaseService {
  static String phoneNumber_ = "";
  static String name_ = "";
  static File? file_;
  static String number = "";
  static String email = "";
  static String password = "";
  static Future<void> signOut() async {
    try {
      // Optionally, update the status to offline if you are tracking user status in Firebase
      await setStatusOffline();

      // Sign out from Firebase Authentication
      await FirebaseAuth.instance.signOut();

      // Navigate user to the login screen or any appropriate screen
      Get.offAll(
          Login()); // Replace LoginPage with your app's login page widget
      ShowSnackBar("Success", "Logged out successfully");
    } catch (e) {
      print(e.toString());
      ShowSnackBar("Error", "Failed to log out");
    }
  }

  static signInWithEmailAndPassword(String email, String password) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        await auth.signOut();
      }

      await auth.signInWithEmailAndPassword(email: email, password: password);

      ShowSnackBar("Success", "Logged in successfully");
      Get.offAll(HomePage());
    } catch (e) {
      print(e.toString());
      ShowSnackBar("Error", "Failed to log in");
    }
  }

  static Future<void> requestOtp(String phoneNumber, String name, String email,
      String password, File file, SignUpState state) async {
    phoneNumber_ = phoneNumber;
    name_ = name;
    file_ = file;
    email = email;
    password = password;
    state.setPress();
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth
        .verifyPhoneNumber(
      phoneNumber: '+88$phoneNumber',
      codeSent: (String verificationId, int? resendToken) async {
        state.setPress();
        Get.to(Otp(
          verificationId: verificationId,
        ));
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
      verificationFailed: (FirebaseAuthException error) {
        print(error.toString());
        ShowSnackBar("Error", errorRead(error.toString()));
        state.setPress();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    )
        .onError(
      (error, stackTrace) {
        state.setPress();
        ShowSnackBar("Error", errorRead(error.toString()));
      },
    );
  }

  static Future<void> verifyOtp(
      String otp, String verificationId, OtpState controller) async {
    try {
      controller.setPress();
      FirebaseAuth auth = FirebaseAuth.instance;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      await auth.signInWithCredential(credential).then(
        (value) async {
          FirebaseStorage storage = FirebaseStorage.instance;
          var sref = storage.ref('$phoneNumber_.jpeg');
          var uploadtask = sref.putFile(file_!);
          await Future.value(uploadtask).then(
            (v) async {
              print(password);
              SignUpState state = Get.put(SignUpState());
              await auth.createUserWithEmailAndPassword(
                  email: state.email.value, password: state.password.value);
              sref.getDownloadURL().then((url) {
                FirebaseDatabase.instance
                    .ref('Accounts')
                    .child(phoneNumber_)
                    .set({
                  'name': name_,
                  'phoneNumber': phoneNumber_,
                  'url': url,
                  'isAdmin': false,
                }).then(
                  (value) {
                    SharedPref.saveData(name_, email, url, phoneNumber_);
                    controller.setPress();
                    ShowSnackBar("Successful", "Verified");
                    Get.to(HomePage());
                  },
                );
              }).onError(
                (error, stackTrace) {
                  print(error.toString());
                  FirebaseAuth.instance.signOut();
                  controller.setPress();
                  ShowSnackBar("Error", errorRead(error.toString()));
                  return;
                },
              );
            },
          ).onError(
            (error, stackTrace) {
              FirebaseAuth.instance.signOut();
              controller.setPress();
              ShowSnackBar("Error", errorRead(error.toString()));
              return;
            },
          );
        },
      ).onError(
        (error, stackTrace) {
          controller.setPress();
          ShowSnackBar("Error", errorRead(error.toString()));
        },
      );
    } catch (e) {
      controller.setPress();
      FirebaseAuth.instance.signOut();
    }
  }

  static Future<void> sendMessage(String sender, String receiver, String name,
      String message, String url) async {
    FirebaseDatabase.instance
        .ref('Accounts')
        .child(sender)
        .child('Chat')
        .child(receiver)
        .set({
      'name': name,
      'phoneNumber': receiver,
      'url': url,
      'latestMessage': message
    });

    FirebaseDatabase.instance
        .ref('Accounts')
        .child(receiver)
        .child('Chat')
        .child(sender)
        .set({
      'name': await SharedPref.getName(),
      'phoneNumber': await SharedPref.getNumber(),
      'url': await SharedPref.getUrl(),
      'latestMessage': message
    });
    String time = DateFormat('h:mm:a').format(DateTime.now());
    FirebaseDatabase.instance
        .ref('Chats')
        .child(sender)
        .child(receiver)
        .child(DateTime.now().microsecondsSinceEpoch.toString())
        .set({
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'time': time
    });

    FirebaseDatabase.instance
        .ref('Chats')
        .child(receiver)
        .child(sender)
        .child(DateTime.now().microsecondsSinceEpoch.toString())
        .set({
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'time': time,
    });
  }

  static Future<void> setStatusOnline() async {
    FirebaseDatabase.instance
        .ref('Accounts')
        .child(number)
        .update({'status': 'Online'});
  }

  static Future<void> setStatusOffline() async {
    String time = DateFormat('h:mm:a').format(DateTime.now());
    FirebaseDatabase.instance
        .ref('Accounts')
        .child(number)
        .update({'status': time});
  }

  static Future<void> sendImage(String sender, String receiver) async {
    String key = DateTime.now().microsecondsSinceEpoch.toString();

    FirebaseDatabase.instance
        .ref('Chats')
        .child(sender)
        .child(receiver)
        .child(key)
        .set({
      'sender': sender,
      'receiver': receiver,
      'message': 'image__',
    });

    FirebaseDatabase.instance
        .ref('Chats')
        .child(receiver)
        .child(sender)
        .child(key)
        .set({
      'sender': sender,
      'receiver': receiver,
      'message': 'image__',
    });

    var picker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picker != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      var sref = storage.ref('${DateTime.now().microsecondsSinceEpoch}.jpeg');
      var uploadtask = sref.putFile(File(picker.path));
      await Future.value(uploadtask).then((v) async {
        sref.getDownloadURL().then((url) {
          String time = DateFormat('h:mm:a').format(DateTime.now());
          FirebaseDatabase.instance
              .ref('Chats')
              .child(sender)
              .child(receiver)
              .child(key)
              .set({
            'sender': sender,
            'receiver': receiver,
            'message': 'image__',
            'time': time,
            'url': url
          });

          FirebaseDatabase.instance
              .ref('Chats')
              .child(receiver)
              .child(sender)
              .child(key)
              .set({
            'sender': sender,
            'receiver': receiver,
            'message': 'image__',
            'time': time,
            'url': url
          });
        });
      });
    }
  }

  static String errorRead(String error) {
    return error.substring(error.indexOf(']') + 1, error.length);
  }

  static Future<void> updateProfile(
      String newName, File newImageFile, String phoneNumber) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      // Assuming the user is logged in
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref('Accounts').child(phoneNumber);

      // Update the name in Firebase Authentication if needed

      // Upload new profile picture to Firebase Storage
      FirebaseStorage storage = FirebaseStorage.instance;
      var sref = storage.ref('$phoneNumber/profilePicture.jpeg');
      var uploadTask = sref.putFile(newImageFile);
      String newImageUrl = await uploadTask
          .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());

      // Update user profile data in Firebase Realtime Database
      await userRef.update({
        'name': newName,
        'url': newImageUrl,
      });

      // Optionally, update local data if you are caching user data
      await SharedPref.saveData(newName, phoneNumber, newImageUrl, phoneNumber);

      ShowSnackBar("Success", "Profile updated successfully");
      Get.to(
          ProfilePage()); // Navigate to profile page or refresh the profile page
    } catch (e) {
      print(e.toString());
      ShowSnackBar("Error", "Failed to update profile");
    }
  }

  static Future<void> signInWithPhoneNumber(String phoneNumber) async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      // Initiate the phone number verification process
      await _auth.signInWithPhoneNumber(
        '+88$phoneNumber',
      );
    } catch (e) {
      print(e.toString());
      ShowSnackBar("Error", "An error occurred. Please try again later.");
    }
  }
}
