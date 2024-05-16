import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // Set the button color to a dark grey, almost black
        backgroundColor: Colors.grey[850], // Button background color

        minimumSize: const Size(double.infinity, 40), // Button size
        padding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 10), // Padding inside the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        elevation: 1, // Shadow elevation
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white, // Text color
          fontWeight: FontWeight.bold, // Bold text style
        ),
      ),
    );
  }
}
