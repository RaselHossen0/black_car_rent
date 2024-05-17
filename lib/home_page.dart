import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'View/BottomNavigationState.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage1> {
  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.white, // Background color of the status bar
      statusBarIconBrightness:
          Brightness.dark, // Brightness of status bar icons
    ));
    Future.delayed(Duration(seconds: 4), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BottomNavigationState()));
    });
  }

  @override
  Widget build(BuildContext context) {
    var hi = MediaQuery.of(context).size.height;
    var wi = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   systemOverlayStyle: SystemUiOverlayStyle(
      //     statusBarIconBrightness: Brightness.dark,
      //     //statusBarColor: Colors.grey[850],
      //   ),
      //   forceMaterialTransparency: true,
      //   toolbarHeight: 0,
      // ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.network(
              'https://w0.peakpx.com/wallpaper/862/739/HD-wallpaper-premio-car-car-bd-cars-cars-bd-new-shape-red-red-wine-toyota-wine.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/car2.jpeg',
                    fit: BoxFit.cover);
              },
            ),
          ),
          Positioned(
              top: hi * 0.13,
              left: 20,
              right: 0,
              bottom: 0,
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: 'Luxury Car Rental & Services\n',
                  style: TextStyle(
                    fontSize: 40,
                    // decoration: TextDecoration.underline,
                    backgroundColor: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  children: [
                    TextSpan(
                      text: 'Car Rental for long tour.\n',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    TextSpan(
                      text: 'Car servicing at home\n',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
              bottom: hi * 0.12,
              child: InkWell(
                onTap: () {
                  print('Continue');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomNavigationState()));
                },
                child: Container(
                  width: wi * 0.74,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: wi * 0.15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.arrow_right_circle_fill,
                        color: Colors.black87,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Positioned(
              bottom: hi * 0.05,
              child: InkWell(
                onTap: () {
                  print('Call Us on WhatsApp');
                  launchUrl(Uri.parse('https://wa.me/message/KRJXER66RGA2H1'));
                },
                child: Container(
                  // width: wi * 0.5,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: wi * 0.15),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.phone_circle,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Call Us on WhatsApp',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
