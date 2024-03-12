//import 'package:app/widgets/custombutton.dart';
import 'package:app/widgets/gradientbutton.dart';
import 'package:app/widgets/savedRoutesButton.dart';
import 'package:flutter/material.dart';
import './widgets/profileField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './widgets/appTheme.dart';
import './widgets/datePickerButton.dart';

class profilePage extends StatefulWidget {
  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  DateTime? selectedDate; // Step 1: Define selectedDate variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Profile',
            style: TextStyle(color: AppTheme.whiteColor),
          ),
        ),
        backgroundColor: AppTheme.bgColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 27.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 48.0.h),
            Center(
              child: CircleAvatar(child: Image.asset('assets/images/orange.png'), maxRadius: 20.r,)
            ),
            SizedBox(height: 99.h),
            Expanded(
              child: Column(
                children: [
                  profileField(
                    text: "Name",
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 20.0.h),
                  profileField(
                    text: "Bio",
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 20.0.h),
                  DatePickerButton(
                    selectedDate: selectedDate,
                    onChanged: (DateTime? date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                  SizedBox(height: 20.0.h),
                  SavedRoutesButton(),
                  SizedBox(height: 179.h),
                  GradientButton(text: "Settings", onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
