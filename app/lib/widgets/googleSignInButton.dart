import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  GoogleSignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white), // Background color of the button
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/google_icon.png', // Path to your Google icon image
            height: 24, // Adjust height of the Google icon
            width: 24, // Adjust width of the Google icon
          ),
          SizedBox(width: 10.0), // Add horizontal space between the icon and the text
          Text(
            'Sign in with Google',
            style: TextStyle(
              color: Colors.black, // Text color
              fontSize: 16.0, // Font size
              fontWeight: FontWeight.bold, // Font weight
            ),
          ),
        ],
      ),
    );
  }
}
