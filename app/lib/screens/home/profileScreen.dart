import 'dart:io';
import 'package:app/screens/home/feed.dart';
import 'package:app/screens/home/settingsPage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/appTheme.dart';
import '../../widgets/datePickerButton.dart';
import '../../widgets/profileField.dart';
import '../../widgets/gradientbutton.dart';
import '../../widgets/savedRoutesButton.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DateTime? selectedDate;
  String email = 'user@example.com'; // Replace with actual email
  bool showSettingsButton = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  File? selectedImage; // Variable to store the selected image

  @override
  void initState() {
    super.initState();
    nameController.addListener(_onFieldChanged);
    bioController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {
      showSettingsButton = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? imageProvider;
    if (selectedImage != null) {
      imageProvider = FileImage(selectedImage!) as ImageProvider<Object>?;
    } else {
      imageProvider = AssetImage('../../assets/images/profile.jpg')
          as ImageProvider<Object>?;
    }
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: AppTheme.lightGreyColor),
        title:
            Text('Profile', style: TextStyle(color: AppTheme.lightGreyColor)),
        backgroundColor: AppTheme.bgColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 27.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 48.0.h),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 40.r, // Adjust this value as needed
                    backgroundImage:
                        imageProvider, // Use the local variable here
                    backgroundColor: Colors
                        .transparent, // Ensure any default background is transparent
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.lightGreyColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(Icons.edit),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: Text(
                email,
                style: TextStyle(color: AppTheme.whiteColor, fontSize: 16.sp),
              ),
            ),
            SizedBox(height: 89.h),
            Column(
              children: [
                profileField(text: "Name", controller: nameController),
                SizedBox(height: 20.0.h),
                profileField(text: "Bio", controller: bioController),
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
                        MaterialPageRoute(builder: (context) => settingsPage()),
                      );
                    },
                  ),
                if (!showSettingsButton)
                  GradientButton(
                    settings: false,
                    text: "Update",
                    onPressed: () {
                      // Implement
                    },
                  ),
                SizedBox(height: 20.0.h),
                GradientButton(
                    text: "Aagah",
                    settings: false,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Feed()),
                      );
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
