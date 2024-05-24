import 'package:app/components/themes/appTheme.dart';
import 'package:app/components/themes/variables.dart';
import 'package:app/components/widgets/custombutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import '../../splashScreen.dart';

class settingsPage extends StatelessWidget {
  final String email = Variables.userEmail;
  settingsPage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: AppTheme.lightGreyColor),
        title: const Text(
          'Profile',
          style: TextStyle(color: AppTheme.lightGreyColor),
        ),
        backgroundColor: AppTheme.bgColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 27.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 48.0.h),
            Center(
              child: CircleAvatar(
                maxRadius: 40.r,
                child: Image.asset('../assets/images/orange.png'),
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: Text(
                email,
                style: TextStyle(color: AppTheme.whiteColor, fontSize: 16.sp),
              ),
            ),
            SizedBox(height: 80.h),
            CustomTextButton(
              text: "Delete Account",
              onPressed: () {},
              textColor: AppTheme.lilacColor,
            ),
            SizedBox(height: 18.h),
            CustomTextButton(
              text: "Change Email",
              onPressed: () {},
              textColor: AppTheme.lilacColor,
            ),
            SizedBox(height: 18.h),
            CustomTextButton(
              text: "Report Bug",
              onPressed: () {},
              textColor: AppTheme.lilacColor,
            ),
         
          ],
        ),
      ),
    );
  }
}
