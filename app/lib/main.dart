import 'package:flutter/material.dart';
import 'splashScreen.dart';
//import './widgets/splashScreenText.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(), // Set SplashScreen as the initial route
    );
  }
}





