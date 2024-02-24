import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // Adjust height as needed
      width: double.infinity, // Expands to full width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF95338A), // Start color
            Color(0xFF5C2A9D), // End color
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white, // White text color
            fontSize: 16.0, // Adjust font size as needed
          ),
        ),
      ),
    );
  }
}
