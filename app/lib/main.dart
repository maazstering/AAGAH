import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'splashScreen.dart';
import './screens/home/mapScreen.dart';
//import './widgets/splashScreenText.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => MaterialApp(
        home: MapScreen(), // Set SplashScreen as the initial route
      ),
    );
  }
}
