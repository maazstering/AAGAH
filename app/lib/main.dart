import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'splashScreen.dart';
import './screens/home/mapScreen.dart';
//import './widgets/splashScreenText.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => const MaterialApp(
        home: SplashScreen(), // Set SplashScreen as the initial route

      ),
    );
  }
}
