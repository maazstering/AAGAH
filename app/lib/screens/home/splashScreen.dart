import 'package:flutter/material.dart';
import '../../widgets/splashScreenText.dart';
import '../auth/loginScreen.dart';
import '../../widgets/appTheme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the home screen after a delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 76.43.h,
              width: 231.8.w,
            ),
            //SizedBox(height: 1), // Add some space between the logo and text
            const SplashText(text: "stay informed"),
            const SizedBox(height: 1),
            const SplashText(text: "stay updated"),
          ],
        ),
      ),
    );
  }
}
