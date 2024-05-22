import 'package:app/components/themes/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogOutButton extends StatelessWidget {
  final String text = "Log Out";
  final VoidCallback onPressed;
  final Color textColor = AppTheme.whiteColor;

  const LogOutButton({
    super.key,
    //required this.text,
    required this.onPressed,
    //required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46.h, // Set the height of the button
      width: 100.w,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppTheme.magentaColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0.r), // Adjust the border radius for square corners
            ),
          ),
          maximumSize: MaterialStateProperty.all(Size(100.w, 100.h)), // gotta change these later
        ),
        
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
