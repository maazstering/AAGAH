// ignore_for_file: camel_case_types

import 'package:app/components/themes/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class profileField extends StatelessWidget {
  final String text;
  final TextEditingController controller;

  const profileField({
    super.key,
    required this.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343.w,
      height: 54.h,
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        style: const TextStyle(fontFamily: 'Mulish'),
        controller: controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16.w),
            border: InputBorder.none,
            hintText: (text)),
      ),
    );
  }
}
