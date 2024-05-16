import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Car {
  final String name;
  final String model;
  final String seats;
  final String image;
  final String perDayCost;

  Car({
    required this.name,
    required this.model,
    required this.seats,
    required this.image,
    required this.perDayCost,
  });

  factory Car.fromJson(Map<dynamic, dynamic> json) {
    return Car(
      name: json['name'] as String,
      model: json['model'] as String,
      seats: json['seats'] as String,
      image: json['image'] as String,
      perDayCost: json['perDayCost'] as String,
    );
  }
}

class CarCard extends StatelessWidget {
  final Car car;

  const CarCard({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width *
        (MediaQuery.of(context).size.width > 600 ? 0.9 : 1); // Responsive width
    double imageHeight = MediaQuery.of(context).size.width *
        (MediaQuery.of(context).size.width > 600
            ? 0.3
            : 0.5); // Responsive image height

    return Card(
      color: Colors.grey[850], // Use theme's dark grey color
      margin: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      elevation: 10, // Shadow effect
      child: Container(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: CachedNetworkImage(
                  imageUrl: car.image,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      Center(child: Icon(Icons.error, color: Colors.red)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(car.name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 6),
                  Text('${car.model}, Seats: ${car.seats}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[300])),
                  SizedBox(height: 4),
                  Text('${car.perDayCost} BDT/day',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final dbRef = FirebaseDatabase.instance.ref().child("services");
  Map<dynamic, dynamic> services = {};
  final dbRef1 = FirebaseDatabase.instance.ref().child("cars");
  List<Car> cars = [];
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.white, // Background color of the status bar
      statusBarIconBrightness:
          Brightness.dark, // Brightness of status bar icons
    ));
    dbRef.onValue.listen((event) {
      final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
      setState(() {
        services = data;
      });
    });
    dbRef1.onValue.listen((event) {
      final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
      final tempCars = <Car>[];
      data.forEach((key, value) {
        tempCars.add(Car.fromJson(Map<dynamic, dynamic>.from(value)));
      });
      setState(() {
        cars = tempCars;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(
          forceMaterialTransparency: false,
          toolbarHeight: 60,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            //statusBarColor: Colors.grey[850],
          ),
          automaticallyImplyLeading: false,
          //backgroundColor: Colors.grey[850],
          title: const Text('Welcome to  Black Rent Car',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22))),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0, bottom: 1),
              child: Text('Cars',
                  style: TextStyle(
                      color: Colors.brown,
                      fontSize: isLargeScreen ? 24 : 19,
                      fontWeight: FontWeight.bold)),
            ),
            cars.isEmpty
                ? Center(child: CircularProgressIndicator())
                : CarouselSlider.builder(
                    itemCount: cars.length,
                    itemBuilder: (context, index, realIndex) {
                      final car = cars[index];
                      return CarCard(car: car);
                    },
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.width *
                          (MediaQuery.of(context).size.width > 600 ? 0.5 : 0.7),
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      aspectRatio: 2.0,
                      enlargeCenterPage: false,
                    ),
                  ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, bottom: 1),
              child: Text('Services',
                  style: TextStyle(
                      fontSize: isLargeScreen ? 24 : 20,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.builder(
                itemCount: services.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  String key = services.keys.elementAt(index);
                  return ServiceTile(
                    title: services[key]['title'],
                    description: services[key]['description'],
                    imageUrl: services[key]['imageUrl'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const ServiceTile({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850], // Dark theme background color
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Smooth rounded corners
      ),
      elevation: 8, // Adds subtle shadow
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Responsive text size for the title
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Text color suitable for dark background
              ),
            ),
            const SizedBox(height: 8),
            // Responsive text size for the description
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[300], // Lighter text color for readability
              ),
            ),
            const SizedBox(height: 16),
            // Image with aspect ratio and error handling
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(8), // Rounded corners for the image
              child: Image.network(
                imageUrl,
                height: MediaQuery.of(context).size.width *
                    0.3, // Responsive image height based on screen width
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: MediaQuery.of(context).size.width * 0.3,
                  color: Colors.grey[800],
                  child: Icon(Icons.error,
                      color: Colors.red[700]), // Error icon with color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
