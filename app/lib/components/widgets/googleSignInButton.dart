import 'package:app/components/themes/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54.h,
      width: 261.w,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppTheme.whiteColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  8.0.r), // Adjust the border radius for square corners
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google.jpg', // Path to your Google icon image
              height: 23.h, // Adjust height of the Google icon
              width: 23.w, // Adjust width of the Google icon
            ),
            SizedBox(
                width: 15.0
                    .w), // Add horizontal space between the icon and the text
            SizedBox(
              height: 23.h,
              width: 192.w,
              child: const Text(
                'Continue with Google',
                style: TextStyle(
                  color: AppTheme.greyColor, // Text color
                  fontSize: 16, // Font size
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
