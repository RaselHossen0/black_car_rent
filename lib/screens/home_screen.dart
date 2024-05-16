import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_car/services/firebase_auth_methods.dart';
import 'package:rent_a_car/widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String name;
  late String email;
  late String phone;
  bool isInitiated = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var db = FirebaseDatabase.instance.reference().child('users');
    if (mounted)
      db.onValue.listen((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        data?.forEach((key, value) {
          print(key + " " + context.read<FirebaseAuthMethods>().user.uid);

          if (value['uid'] == context.read<FirebaseAuthMethods>().user.uid) {
            print(value);
            setState(() {
              name = value['name'];
              email = value['email'];
              phone = value['phone'];
            });
            isInitiated = true;
          }
        });
      });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   systemOverlayStyle: SystemUiOverlayStyle(
      //     statusBarIconBrightness: Brightness.dark,
      //     statusBarColor: Colors.grey[850],
      //   ),
      //   // leading: IconButton(
      //   //   icon: Icon(Icons.arrow_back_ios, color: Colors.white),
      //   //   onPressed: () => Navigator.pop(context),
      //   // ),
      //   title: Text('Profile', style: TextStyle(color: Colors.brown)),
      //   centerTitle: true,
      //   // backgroundColor: Colors.grey[850], // Dark grey, not pure black
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
            ),
            Image.network(
                'https://cdni.iconscout.com/illustration/premium/thumb/user-profile-2839460-2371086.png?f=webp',
                width: 150,
                height: 160), // Add image URL (optional
            const SizedBox(height: 20),
            if (isInitiated)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 1,
                    margin: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10), // Adjust horizontal margin
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      tileColor: Colors.grey[200], // Background color
                      leading: Icon(Icons.person, color: Colors.black),
                      title: Text(
                        name ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (isInitiated)
                    Card(
                      elevation: 1,
                      margin: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10), // Adjust horizontal margin
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        tileColor: Colors.grey[200], // Background color
                        leading: Icon(Icons.email, color: Colors.black),
                        title: Text(
                          '${email}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  if (isInitiated)
                    Card(
                      elevation: 1,
                      margin: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10), // Adjust horizontal margin
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        tileColor: Colors.grey[200], // Background color
                        leading: Icon(Icons.phone, color: Colors.black),
                        title: Text(
                          'Phone: ${phone}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

            const SizedBox(height: 30),
            if (!user.emailVerified && !user.isAnonymous)
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: CustomButton(
                  onTap: () => context
                      .read<FirebaseAuthMethods>()
                      .sendEmailVerification(context),
                  text: 'Verify Email',
                ),
              ),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: CustomButton(
                onTap: () =>
                    context.read<FirebaseAuthMethods>().signOut(context),
                text: 'Sign Out',
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: CustomButton(
                onTap: () =>
                    context.read<FirebaseAuthMethods>().deleteAccount(context),
                text: 'Delete Account',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
