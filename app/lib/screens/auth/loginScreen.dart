import 'dart:convert';
import 'package:app/components/themes/appTheme.dart';
import 'package:app/components/themes/variables.dart';
import 'package:app/components/widgets/customTextField.dart';
import 'package:app/components/widgets/custombutton.dart';
import 'package:app/components/widgets/googleSignInButton.dart';
import 'package:app/components/widgets/gradientbutton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/widgets/orWidget.dart';
import 'signupScreen.dart';
import '../home/feed.dart'; // Ensure the correct path

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  Future<void> loginUser(BuildContext context) async {
    final String apiUrl = Variables.address + '/login';
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['token'] != null) {
          final token =
              responseData['token']; // Corrected to use the actual token

          // Save the token
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);
          print('Token saved: $token'); // Debugging line

          // Navigate to FeedWidget
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const FeedWidget(),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Login Failed'),
              content: const Text('Token is null. Please try again.'),
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
      } else {
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
      print('Error: $e');
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
  }

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
                      await loginUser(context);
                    },
                  ),
                  SizedBox(height: 12.0.h),
                  CustomTextButton(
                    text: "Forgot Password?",
                    onPressed: () {},
                    textColor: AppTheme.neonPurpleColor,
                  ),
                  SizedBox(height: 31.h),
                  // const OrDivider(),
                  // SizedBox(height: 24.h),
                  // GoogleSignInButton(onPressed: () {}),
                  SizedBox(height: 110.h),
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
                    textColor: AppTheme.neonPurpleColor,
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
