import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../themes/appTheme.dart';

// Custom widget for email text field
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.text,
    required this.icon,
    required this.obscureText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.h,
      width: 315.w,
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          color: AppTheme.greyColor,
        ), // Set text color to grey
        decoration: InputDecoration(
          filled: true, // Fill the background
          fillColor:
              AppTheme.lightGreyColor, // Set the background color to light grey
          prefixIcon: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, color: AppTheme.greyColor), // Set icon color to grey
              Positioned(
                left: 42.w, // Adjust the position of the line
                top: 4.h, // Adjust the position of the line
                bottom: 4.h, // Adjust the position of the line
                child: Container(
                  width: 1.w, // Set the width of the line
                  color: Colors.grey[600], // Set the color of the line
                ),
              ),
            ],
          ),
          hintText: text,
          labelStyle: const TextStyle(
            color: AppTheme.greyColor,
            fontFamily: 'Mulish',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0.r),
          ),
        ),
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}
