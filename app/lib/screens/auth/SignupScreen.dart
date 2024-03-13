import 'package:app/screens/auth/loginScreen.dart';
import 'package:app/widgets/custombutton.dart';
import 'package:app/widgets/googleSignInButton.dart';
import 'package:flutter/material.dart';
import '../../widgets/customTextField.dart';
import '../../widgets/gradientbutton.dart';
import '../../widgets/appTheme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/orWidget.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppTheme.bgColor, // Set background color to black
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 38.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 100.h),
                  Image.asset(
                    'assets/images/logo.png', // Path to your image
                    height: 76.43.h,
                    width: 231.8.w,
                  ),
                  SizedBox(height: 50.h),
                  CustomTextField(
                    controller: TextEditingController(),
                    text: "Name",
                    icon: Icons.person,
                    obscureText: false,
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: TextEditingController(),
                    text: "Email",
                    icon: Icons.email,
                    obscureText: false,
                  ),
                  SizedBox(height: 10.0.h),
                  CustomTextField(
                    controller: TextEditingController(),
                    text: "Password",
                    icon: Icons.key,
                    obscureText: true,
                  ),
                  SizedBox(height: 14.0.h),
                  GradientButton(
                      text: "Create Account",
                      settings: false,
                      onPressed: () {}),
                  SizedBox(height: 34.h),
                  OrDivider(),
                  SizedBox(height: 23.h),
                  GoogleSignInButton(onPressed: () {}),
                  SizedBox(height: 114.h),
                  CustomTextButton(
                      text: "I already have an Account",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      textColor: AppTheme.lavenderColor)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
