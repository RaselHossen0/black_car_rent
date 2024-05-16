import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/custom_textfield.dart';

class Booking {
  String id;
  String name;
  String email;
  String details;
  // String carModel;
  // String pickupDate;
  // String returnDate;

  Booking({
    required this.id,
    required this.name,
    required this.email,
    required this.details,
    // required this.carModel,
    // required this.pickupDate,
    // required this.returnDate
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'details': details,
        // 'carModel': carModel,
        // 'pickupDate': pickupDate,
        // 'returnDate': returnDate,
      };
}

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final carModelController = TextEditingController();
  final pickupDateController = TextEditingController();
  final returnDateController = TextEditingController();
  final dbRef = FirebaseDatabase.instance.ref().child("bookings");
  final dbRef1 = FirebaseDatabase.instance.ref().child("Emails");
  String contactEmail = '';
  final detailsController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dbRef1.onValue.listen((event) {
      final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
      setState(() {
        contactEmail = data['email'];
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    detailsController.dispose();
    // carModelController.dispose();
    // pickupDateController.dispose();
    // returnDateController.dispose();
    super.dispose();
  }

  Future<void> sendEmail(Booking booking) async {
    final Email email = Email(
      body:
          'Your query details:\nName: ${booking.name}\nPhone: ${booking.email}\n Details: ${booking.details}\n',
      subject: 'New Booking Request',
      recipients: [contactEmail], // Add the real recipient's email address
      isHTML: true,
    );
    String phoneNumber =
        "8801315147883"; // Replace with the actual phone number
    String message = Uri.encodeFull(
        'New Booking Request-\n\nName: ${booking.name}\nPhone: ${booking.email}\n Details: ${booking.details}\n');
    await launchUrl(Uri.parse('https://wa.me/$phoneNumber?text=$message'));

    await FlutterEmailSender.send(email);
  }

  Future<void> saveBooking() async {
    if (_formKey.currentState!.validate()) {
      var newBooking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        email: emailController.text,
        details: detailsController.text,
        // carModel: carModelController.text,
        // pickupDate: pickupDateController.text,
        // returnDate: returnDateController.text,
      );

      dbRef.child(newBooking.id).set(newBooking.toJson()).then((_) {
        sendEmail(newBooking);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sent Successfully!')));
        // Optionally clear the form or navigate the user to another page
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to book car: $error')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        // title: Text('Book Your Car or Contact Us'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Center(
              child: Text('Book Your Car ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 27)),
            ),
            Center(
              child: Text('or',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 27)),
            ),
            Center(
              child: Text('Request Car Servicing',
                  style: TextStyle(
                      color: Colors.brown,
                      fontWeight: FontWeight.bold,
                      fontSize: 27)),
            ),
            Image.network(
                'https://static.vecteezy.com/system/resources/previews/012/001/342/non_2x/car-rental-booking-reservation-and-sharing-using-service-mobile-application-with-route-or-points-location-in-hand-drawn-cartoon-flat-illustration-vector.jpg',
                height: 150),
            SizedBox(height: 20), // Add some space at the top (20 pixels
            CustomTextField(
              controller: nameController,
              hintText: 'Full Name',
              // decoration: InputDecoration(labelText: 'Full Name'),
              // validator: RequiredValidator(errorText: 'This field is required'),
            ),
            SizedBox(height: 20), // Add some space between the fields
            CustomTextField(
              controller: emailController,
              hintText: 'Phone Number',
              // decoration: InputDecoration(labelText: 'Email'),
              // validator: MultiValidator([
              //   RequiredValidator(errorText: 'Email is required'),
              //   // EmailValidator(errorText: 'Enter a valid email address'),
              // ]),
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: detailsController,

              hintText: 'Details',
              // decoration: InputDecoration(labelText: 'Email'),
              // validator: MultiValidator([
              //   RequiredValidator(errorText: 'Email is required'),
              //   // EmailValidator(errorText: 'Enter a valid email address'),
              // ]),
            ),
            SizedBox(height: 20),

            // CustomTextField(
            //   controller: carModelController,
            //   hintText: 'Car Model',
            // ),
            // SizedBox(height: 20),
            // TextFormField(
            //   controller: pickupDateController,
            //   decoration: InputDecoration(
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //       borderSide:
            //           const BorderSide(color: Colors.transparent, width: 0),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //       borderSide:
            //           const BorderSide(color: Colors.transparent, width: 0),
            //     ),
            //     contentPadding:
            //         const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            //     filled: true,
            //     fillColor: const Color(0xffF5F6FA),
            //     hintText: 'Pickup Date',
            //     hintStyle: const TextStyle(
            //       fontSize: 14,
            //       fontWeight: FontWeight.w400,
            //     ),
            //   ),
            //   validator: RequiredValidator(errorText: 'This field is required'),
            //   onTap: () async {
            //     DateTime? date = await showDatePicker(
            //       context: context,
            //       initialDate: DateTime.now(),
            //       firstDate: DateTime.now(),
            //       lastDate: DateTime(2100),
            //     );
            //     if (date != null) {
            //       pickupDateController.text = date
            //           .toIso8601String()
            //           .split('T')[0]; // Format the date text.
            //     }
            //   },
            // ),
            // SizedBox(height: 20),
            // TextFormField(
            //   controller: returnDateController,
            //   decoration: InputDecoration(
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //       borderSide:
            //           const BorderSide(color: Colors.transparent, width: 0),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //       borderSide:
            //           const BorderSide(color: Colors.transparent, width: 0),
            //     ),
            //     contentPadding:
            //         const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            //     filled: true,
            //     fillColor: const Color(0xffF5F6FA),
            //     hintText: 'Return Date',
            //     hintStyle: const TextStyle(
            //       fontSize: 14,
            //       fontWeight: FontWeight.w400,
            //     ),
            //   ),
            //   validator: RequiredValidator(errorText: 'This field is required'),
            //   onTap: () async {
            //     DateTime? date = await showDatePicker(
            //       context: context,
            //       initialDate: DateTime.now(),
            //       firstDate: DateTime.now(),
            //       lastDate: DateTime(2100),
            //     );
            //     if (date != null) {
            //       returnDateController.text = date
            //           .toIso8601String()
            //           .split('T')[0]; // Format the date text.
            //     }
            //   },
            // ),
            // SizedBox(height: 20),
            InkWell(
              onTap: () {
                saveBooking();
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
