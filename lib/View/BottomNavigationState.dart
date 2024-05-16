import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rent_a_car/screens/MainScreen.dart';
import 'package:rent_a_car/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/findCost.dart';

class BottomNavigationState extends StatefulWidget {
  const BottomNavigationState({super.key});

  @override
  State<BottomNavigationState> createState() => _BottomNavigationStateState();
}

class _BottomNavigationStateState extends State<BottomNavigationState> {
  int currentIndex = 0;
  Widget screen = MainScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          //statusBarColor: Colors.grey[850],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const [
          Icons.home_max_outlined,
          CupertinoIcons.phone_circle_fill,
          // Icons.reviews_outlined,
          Icons.car_crash,
          Icons.person_2_outlined,
        ],
        height: 60,
        gapWidth: 2,
        backgroundColor: Colors.white,
        inactiveColor: Colors.black,
        activeIndex: currentIndex,
        activeColor: Colors.deepOrange,
        elevation: 20,
        gapLocation: GapLocation.end,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        onTap: (p0) {
          currentIndex = p0;
          if (currentIndex == 0) {
            screen = MainScreen();
          }
          if (currentIndex == 2) {
            screen = BookingPage();
          }
          if (currentIndex == 1) {
            launchUrl(Uri.parse('https://wa.me/message/KRJXER66RGA2H1'));
          }
          // if (currentIndex == 2) {
          //   screen = ReviewPage();
          // }
          if (currentIndex == 3) {
            screen = HomeScreen();
          }
          // else if (currentIndex == 1) {
          //   screen = const SearchUser();
          // } else if (currentIndex == 3) {
          //   screen = ProfilePage();
          // }

          setState(() {});
        },
      ),
      body: screen,
    );
  }
}
