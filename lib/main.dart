import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_car/screens/login_email_password_screen.dart';
import 'package:rent_a_car/screens/login_screen.dart';
import 'package:rent_a_car/screens/phone_screen.dart';
import 'package:rent_a_car/screens/signup_email_password_screen.dart';
import 'package:rent_a_car/services/firebase_auth_methods.dart';

import 'View/BottomNavigationState.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rent Black Car',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        ),
        home: const HomePage1(),
        routes: {
          EmailPasswordSignup.routeName: (context) =>
              const EmailPasswordSignup(),
          EmailPasswordLogin.routeName: (context) => const EmailPasswordLogin(),
          PhoneScreen.routeName: (context) => const PhoneScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const BottomNavigationState();
    }
    return const LoginScreen();
  }
}
