//import 'package:app/widgets/custombutton.dart';
import 'package:app/screens/settingsPage.dart';
import 'package:app/components/gradientbutton.dart';
import 'package:app/components/savedRoutesButton.dart';
import 'package:flutter/material.dart';
import '../components/profileField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/appTheme.dart';
import '../components/datePickerButton.dart';
import '../components/variables.dart';

class profilePage extends StatefulWidget {
  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  DateTime? selectedDate;
  String email = Variables.userEmail;
  bool showSettingsButton = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add listeners to text field controllers
    nameController.addListener(_onFieldChanged);
    bioController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

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
              child: CircleAvatar(maxRadius: 40.r,child: Image.asset('assets/images/orange.png'),)
            ),
            SizedBox(height: 10.h,),
            Center(child: Text(email,style: TextStyle(color: AppTheme.whiteColor,fontSize: 16.sp),)),
            SizedBox(height: 89.h),
            Expanded(
              child: Column(
                children: [
                  profileField(
                    text: "Name",
                    controller: nameController,
                  ),
                  SizedBox(height: 20.0.h),
                  profileField(
                    text: "Bio",
                    controller: bioController,
                  ),
                  SizedBox(height: 20.0.h),
                  DatePickerButton(
                    selectedDate: selectedDate,
                    onChanged: (DateTime? date) {
                      setState(() {
                        selectedDate = date;
                      });
                      _onFieldChanged();
                    },
                  ),
                  SizedBox(height: 20.0.h),
                  SavedRoutesButton(),
                  SizedBox(height: 150.h),
                  if (showSettingsButton)
                    GradientButton(
                      text: "Settings",
                      settings: true,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => settingsPage(),
                          ),
                        );
                      },
                    ),
                  if (!showSettingsButton)
                    GradientButton(
                      settings: false,
                      text: "Update",
                      onPressed: () {
                        // Implement update logic here
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onFieldChanged() {
    setState(() {
      showSettingsButton = false;
    });
  }
}
