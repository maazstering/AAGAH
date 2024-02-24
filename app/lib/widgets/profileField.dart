import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './appTheme.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  CustomTextField({
    required this.hintText,
    required this.controller,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343.w,
      height: 54.h,
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}
