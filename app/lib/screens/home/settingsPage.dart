// // ignore_for_file: file_names
// import 'package:app/components/themes/appTheme.dart';
// import 'package:app/components/themes/variables.dart';
// import 'package:app/components/widgets/custombutton.dart';
// import 'package:app/components/widgets/logoutButton.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../splashScreen.dart';

// // ignore: camel_case_types
// class settingsPage extends StatelessWidget {
//   final String email = Variables.userEmail;
//   settingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.bgColor,
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         iconTheme: const IconThemeData(color: AppTheme.lightGreyColor),
//         title: const Text(
//           'Profile',
//           style: TextStyle(color: AppTheme.lightGreyColor),
//         ),
//         backgroundColor: AppTheme.bgColor,
//         centerTitle: true,
//       ),
//       body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 27.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               SizedBox(height: 48.0.h),
//               Center(
//                   child: CircleAvatar(
//                 maxRadius: 40.r,
//                 child: Image.asset('../assets/images/orange.png'),
//               )),
//               SizedBox(
//                 height: 10.h,
//               ),
//               Center(
//                   child: Text(
//                 email,
//                 style: TextStyle(color: AppTheme.whiteColor, fontSize: 16.sp),
//               )),
//               SizedBox(
//                 height: 80.h,
//               ),
//               CustomTextButton(
//                   text: "Delete Account",
//                   onPressed: () {},
//                   textColor: AppTheme.lilacColor),
//               SizedBox(
//                 height: 18.h,
//               ),
//               CustomTextButton(
//                   text: "Change Email",
//                   onPressed: () {},
//                   textColor: AppTheme.lilacColor),
//               SizedBox(
//                 height: 18.h,
//               ),
//               CustomTextButton(
//                   text: "Report Bug",
//                   onPressed: () {},
//                   textColor: AppTheme.lilacColor),

//             SizedBox(
//                 height: 200.h,
//               ),
//             LogOutButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => const SplashScreen(),
//                   ),
//                 );
//               },
//             )
//             ],
//           )),
//     );
//   }
// }












// File: settingsPage.dart

import 'package:app/components/themes/appTheme.dart';
import 'package:app/components/themes/variables.dart';
import 'package:app/components/widgets/custombutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import '../../splashScreen.dart';

class settingsPage extends StatelessWidget {
  final String email = Variables.userEmail;
  settingsPage({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/logout'), // Replace with your API URL
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
        (route) => false,
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: AppTheme.lightGreyColor),
        title: const Text(
          'Profile',
          style: TextStyle(color: AppTheme.lightGreyColor),
        ),
        backgroundColor: AppTheme.bgColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 27.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 48.0.h),
            Center(
              child: CircleAvatar(
                maxRadius: 40.r,
                child: Image.asset('../assets/images/orange.png'),
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: Text(
                email,
                style: TextStyle(color: AppTheme.whiteColor, fontSize: 16.sp),
              ),
            ),
            SizedBox(height: 80.h),
            CustomTextButton(
              text: "Delete Account",
              onPressed: () {},
              textColor: AppTheme.lilacColor,
            ),
            SizedBox(height: 18.h),
            CustomTextButton(
              text: "Change Email",
              onPressed: () {},
              textColor: AppTheme.lilacColor,
            ),
            SizedBox(height: 18.h),
            CustomTextButton(
              text: "Report Bug",
              onPressed: () {},
              textColor: AppTheme.lilacColor,
            ),
            SizedBox(height: 200.h),
            ElevatedButton(
              onPressed: () => _handleLogout(context),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
