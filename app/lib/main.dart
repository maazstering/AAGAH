import 'package:app/screens/home/feed.dart';
import 'package:app/screens/home/location_search_screen.dart';
import 'package:app/screens/home/mapScreen.dart';
import 'package:app/splashScreen.dart';
// import 'package:app/screens/home/map_screen.dart';
// import 'package:app/screens/home/trail_map.dart';
// import 'package:app/splashScreen.dart';
// import 'package:app/screens/home/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'splashScreen.dart';


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
        debugShowCheckedModeBanner: false,
        home: SplashScreen(), // Set SplashScreen as the initial route
      ),
    );
  }
}
