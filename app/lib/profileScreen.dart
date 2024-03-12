import 'package:app/widgets/custombutton.dart';
import 'package:app/widgets/gradientbutton.dart';
import 'package:app/widgets/savedRoutesButton.dart';
import 'package:flutter/material.dart';
import './widgets/profileField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './widgets/appTheme.dart';

class profilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false, // change this later
        title: const Center(
            child: Text(
          'Profile',
          style: TextStyle(color: AppTheme.whiteColor),
        )),
        backgroundColor: AppTheme.bgColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 27.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Icon with space from AppBar
            SizedBox(height: 48.0.h),
            Center(
              child: Icon(
                Icons.person_2_outlined, // Replace with your desired icon
                size: 80.0.h,
                color: AppTheme.lightGreyColor, // Adjust the size as needed
              ),
            ),
            SizedBox(
              height: 99.h,
            ),
            // Text Fields
            Expanded(
              child: Column(
                children: [
                  profileField(
                    text: "Name",
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 20.0.h),
                  profileField(
                      text: "Bio", controller: TextEditingController()),
                  SizedBox(height: 20.0.h),
                  profileField(
                    text: "Date of Birth",
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 20.0.h),
                  SavedRoutesButton(),
                  SizedBox(height: 179.h,),
                  GradientButton(text: "Settings", onPressed: (){})
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
