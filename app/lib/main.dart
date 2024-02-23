import 'package:app/widgets/custombutton.dart';
import 'package:flutter/material.dart';
import 'widgets/customTextField.dart';
import 'widgets/gradientbutton.dart';

void main() {
  runApp(LoginScreen());
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor:
            Color.fromARGB(255, 30, 30, 30), // Set background color to black
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Path to your image
                    height: 100, // Adjust height as needed
                  ),
                  SizedBox(height: 30),
                  CustomTextField(
                    controller: TextEditingController(),
                    text: "Email",
                    icon: Icons.email,
                    obscureText: false,
                  ),
                  SizedBox(height: 10.0),
                  CustomTextField(
                    controller: TextEditingController(),
                    text: "Password",
                    icon: Icons.key,
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  GradientButton(text: "Login", onPressed: () {}),
                  SizedBox(height: 10.0), // Adjust the spacing between buttons
                  CustomTextButton(
                      text: "Forgot Password?",
                      onPressed: () {},
                      textColor: Color.fromARGB(255, 145, 40, 250)),
                  SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google.jpg',
                          height: 20, // Adjust height of the Google logo
                          width: 20, // Adjust width of the Google logo
                        ),
                        SizedBox(
                            width:
                                10.0), // Add horizontal space between the icon and the text
                        Text(
                          'Sign in with Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 60.0),
                  CustomTextButton(
                      text: "I don't have an Account",
                      onPressed: () {},
                      textColor: Color.fromARGB(255, 145, 40, 250))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
