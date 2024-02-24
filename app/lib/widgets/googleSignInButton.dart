import 'package:flutter/material.dart';
import 'appTheme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  GoogleSignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      width: 261.w,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppTheme.whiteColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0.r), // Adjust the border radius for square corners
            ),
          ), // Background color of the button
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google.jpg', // Path to your Google icon image
              height: 23.h, // Adjust height of the Google icon
              width: 23.w, // Adjust width of the Google icon
            ),
            SizedBox(width: 15.0.w), // Add horizontal space between the icon and the text
            Container(
              height: 23.h,
              width: 192.w,
              child: Text(
                'Continue with Google',
                style: TextStyle(
                  color: AppTheme.greyColor, // Text color
                  fontSize: 16.0.sp, // Font size
                  fontWeight: FontWeight.bold, // Font weight
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
