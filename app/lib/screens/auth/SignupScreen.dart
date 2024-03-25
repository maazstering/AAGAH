import 'dart:convert';
import 'package:app/widgets/custombutton.dart';
import 'package:app/widgets/googleSignInButton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/screens/home/profileScreen.dart';
import 'package:app/screens/auth/loginScreen.dart';
import 'package:app/widgets/customTextField.dart';
import 'package:app/widgets/gradientbutton.dart';
import 'package:app/widgets/appTheme.dart';
import 'package:app/widgets/orWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppTheme.bgColor,
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
                    'assets/images/logo.png',
                    height: 76.43.h,
                    width: 231.8.w,
                  ),
                  SizedBox(height: 50.h),
                  CustomTextField(
                    controller: nameController,
                    text: "Name",
                    icon: Icons.person,
                    obscureText: false,
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: emailController,
                    text: "Email",
                    icon: Icons.email,
                    obscureText: false,
                  ),
                  SizedBox(height: 10.0.h),
                  CustomTextField(
                    controller: passwordController,
                    text: "Password",
                    icon: Icons.key,
                    obscureText: true,
                  ),
                  SizedBox(height: 14.0.h),
                  GradientButton(
                    text: "Create Account",
                    settings: false,
                    onPressed: () async {
                      final String apiUrl = 'http://192.168.56.1:3000/signup';
                      String name = nameController.text.trim();
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();

                      try {
                        final response = await http.post(
                          Uri.parse(apiUrl),
                          body: jsonEncode({
                            'name': name,
                            'email': email,
                            'password': password
                          }),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 201) {
                          // Account created successfully
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        } else {
                          // Error occurred
                          final responseData = json.decode(response.body);
                          String errorMessage = responseData['errors']
                                  ['email'] ??
                              'Failed to create account. Please try again.';
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Signup Failed'),
                              content: Text(errorMessage),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      } catch (e) {
                        // Network error
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Network Error'),
                            content: Text(e.toString()),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
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
                    textColor: AppTheme.lavenderColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
