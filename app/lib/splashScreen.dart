import 'package:flutter/material.dart';
import './widgets/splashScreenText.dart';
import 'loginScreen.dart';
import './widgets/appColors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the home screen after a delay
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 100,
            ),
            //SizedBox(height: 1), // Add some space between the logo and text
            SplashText(text: "stay informed"),
            SizedBox(height: 1),
            SplashText(text: "stay updated"),
          ],
        ),
      ),
    );
  }
}