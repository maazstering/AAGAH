import 'package:flutter/material.dart';

void main() {
  runApp(LoginScreen());
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor:
            Color.fromARGB(239, 15, 15, 15), // Set background color to black
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
                  SizedBox(height: 40),
                  TextField(
                    style: TextStyle(
                        color: Color.fromARGB(
                            246, 218, 215, 215)), // Set text color to white
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email,
                          color: Color.fromARGB(
                              246, 218, 215, 215)), // Set icon color to white
                      labelText: 'Email',
                      labelStyle: TextStyle(
                          color: Color.fromARGB(246, 218, 215,
                              215)), // Set label text color to white
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    style: TextStyle(
                        color: Color.fromARGB(
                            246, 218, 215, 215)), // Set text color to white
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock,
                          color: Color.fromARGB(
                              246, 218, 215, 215)), // Set icon color to white
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color: Color.fromARGB(246, 218, 215,
                              215)), // Set label text color to white
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 50, // Adjust height as needed
                    width: double.infinity, // Expands to full width
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF95338A), // Start color
                          Color(0xFF5C2A9D), // End color
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Add your login logic here
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white, // White text color
                          fontSize: 16.0, // Adjust font size as needed
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0), // Adjust the spacing between buttons
                  SizedBox(
                    height: 40, // Set the height of the button
                    width: double.infinity, // Expands to full width
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 39, 39, 39))),
                      child: Text('Forgot password?',
                          style: TextStyle(
                              color: Color.fromARGB(255, 126, 2, 250))),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock),
                        SizedBox(width: 10.0),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 39, 39, 39))),
                    child: Text("I don't have an account",
                        style:
                            TextStyle(color: Color.fromARGB(255, 126, 2, 250))),
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
