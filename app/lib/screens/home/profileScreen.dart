import 'dart:convert';
import 'dart:io';
import 'package:app/components/themes/appTheme.dart';
import 'package:app/components/themes/variables.dart';
import 'package:app/components/widgets/bottomNavigationCard.dart';
import 'package:app/components/widgets/gradientbutton.dart';
import 'package:app/components/widgets/locationSearchField.dart';
import 'package:app/components/widgets/logoutButton.dart';
import 'package:app/components/widgets/profileField.dart';
import 'package:app/components/widgets/savedRoutesButton.dart';
import 'package:app/screens/home/feed.dart';
import 'package:app/screens/home/settingsPage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../splashScreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int? age;
  String email = '';
  String name = '';
  String bio = '';
  bool showSettingsButton = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  File? selectedImage; // Variable to store the selected image

  @override
  void initState() {
    super.initState();
    nameController.addListener(_onFieldChanged);
    bioController.addListener(_onFieldChanged);
    fetchProfile();
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

  Future<void> _handleLogout(BuildContext context) async {
    final response = await http.get(
      Uri.parse('https://aagah.onrender.com/logout'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
        (route) => false,
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed. Please try again.'),
        ),
      );
    }
  }

  Future<void> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token != null) {
      final uri = Uri.parse('${Variables.address}/profile/selfProfile');
      try {
        final response = await http.get(
          uri,
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          setState(() {
            email = responseData['email'] ?? 'No Email';
            name = responseData['name'] ?? 'No Name';
            bio = responseData['bio'] ?? 'No Bio';
            age = responseData['age'];
            nameController.text = name;
            bioController.text = bio;
          });
        } else {
          print('Failed to load profile: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Error fetching profile: $e');
      }
    } else {
      print('Token is null');
      // Handle the case where the token is null (e.g., navigate to login)
    }
  }

  Future<void> updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token != null) {
      final uri = Uri.parse('${Variables.address}/profile/selfProfile');
      var request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $token';

      if (selectedImage != null) {
        request.files.add(
            await http.MultipartFile.fromPath('image', selectedImage!.path));
      }
      request.fields['name'] = nameController.text;
      request.fields['bio'] = bioController.text;
      if (age != null) {
        request.fields['age'] = age.toString();
      }

      try {
        final response = await request.send();

        if (response.statusCode == 200) {
          print('Profile updated successfully');
          setState(() {
            showSettingsButton = true;
          });
        } else {
          print('Failed to update profile: ${response.statusCode}');
          final responseBody = await response.stream.bytesToString();
          print('Response body: $responseBody');
        }
      } catch (e) {
        print('Error updating profile: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? imageProvider;
    if (selectedImage != null) {
      imageProvider = FileImage(selectedImage!) as ImageProvider<Object>?;
    } else {
      imageProvider = const AssetImage('assets/images/profile.jpg')
          as ImageProvider<Object>?;
    }
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: AppTheme.lightGreyColor),
        title:
            const Text('Profile', style: TextStyle(color: AppTheme.lilacColor)),
        backgroundColor: AppTheme.bgColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 27.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20.0.h),
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
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.lightGreyColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(Icons.edit),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: Text(
                email, // change this to, actual user email to be used
                style: TextStyle(color: AppTheme.whiteColor, fontSize: 16.sp),
              ),
            ),
            SizedBox(height: 40.h),
            Column(
              children: [
                profileField(text: "Name", controller: nameController),
                SizedBox(height: 10.0.h),
                profileField(text: "Bio", controller: bioController),
                SizedBox(height: 10.0.h),
                profileField(
                  text: "Age",
                  controller:
                      TextEditingController(text: age?.toString() ?? ''),
                ),
                SizedBox(height: 10.0.h),
                //for testing purposes
                //LocationSearchWidget(),
                const SavedRoutesButton(),
                SizedBox(height: 60.h),
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
                    onPressed: updateProfile,
                  ),
                SizedBox(height: 10.0.h),
                GradientButton(
                  settings: false,
                  text: 'Logout',
                  onPressed: () => _handleLogout(context),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          // Handle navigation to different screens
        },
      ),
    );
  }
}
