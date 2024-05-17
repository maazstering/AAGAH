import 'dart:convert';
import 'package:app/screens/home/feed.dart';
import 'package:app/widgets/variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/widgets/custombutton.dart';
import 'package:app/widgets/googleSignInButton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/customTextField.dart';
import '../../widgets/gradientbutton.dart';
import '../../widgets/orWidget.dart';
import 'SignupScreen.dart';
import '../../widgets/appTheme.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

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
                  SizedBox(height: 12.0.h),
                  GradientButton(
                    text: "Login",
                    settings: false,
                    onPressed: () async {
                      final String apiUrl = Variables.address + ('/login');
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();

                      try {
                        final response = await http.post(
                          Uri.parse(apiUrl),
                          body: jsonEncode(
                              {'email': email, 'password': password}),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 200) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FeedWidget(),
                            ),
                          );
                        } else {
                          // Use response body to show more detailed error
                          final responseData = json.decode(response.body);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Login Failed'),
                              content: Text(responseData['message'] ??
                                  'Invalid email or password. Please try again.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      } catch (e) {
                        // Catch network errors and show them in a dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Network Error'),
                            content: Text(e.toString()),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 12.0.h),
                  CustomTextButton(
                    text: "Forgot Password?",
                    onPressed: () {},
                    textColor: const Color.fromARGB(255, 128, 0, 255),
                  ),
                  SizedBox(height: 31.h),
                  const OrDivider(),
                  SizedBox(height: 24.h),
                  GoogleSignInButton(onPressed: () {}),
                  SizedBox(height: 80.h),
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
                    textColor: const Color.fromARGB(255, 145, 40, 250),
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
