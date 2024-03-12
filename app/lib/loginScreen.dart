import 'package:app/profileScreen.dart';
import 'package:app/widgets/custombutton.dart';
import 'package:app/widgets/googleSignInButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/customTextField.dart';
import 'widgets/gradientbutton.dart';
import 'SignupScreen.dart';
import 'widgets/appTheme.dart';
import './widgets/orWidget.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppTheme.bgColor, // Set background color to black
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 38.w),
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
                  SizedBox(height: 12.0.h),
                  GradientButton(text: "Login", onPressed: () {
                    print(Text("button pressed"));
                    Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => profilePage(),
                          ),
                        );
                  }),
                  SizedBox(
                      height: 12.0.h), // Adjust the spacing between buttons
                  CustomTextButton(
                      text: "Forgot Password?",
                      onPressed: () {},
                      textColor: const Color.fromARGB(
                          255, 128, 0, 255)), // CHANGE COLOR LATER
                  SizedBox(height: 31.h),
                  OrDivider(),
                  SizedBox(height: 24.h),
                  GoogleSignInButton(onPressed: (){}),
                  SizedBox(height: 80.h), // to be changed
                  //Expanded(child: const Spacer(flex: 3)),
                  CustomTextButton(
                      text: "I don't have an Account",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      textColor: Color.fromARGB(255, 145, 40, 250),
                    ),
                    //const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
