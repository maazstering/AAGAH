import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/appTheme.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Uncomment the following line to add a title
        // title: Text('Home'),
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                // Handle menu button press
                print('Menu button pressed');
              },
            ),
            SizedBox(width: 16), // Adjust the space between the icon and the logo
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Home Page Content'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // Handle Home button press
                print('Home button pressed');
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // Handle Add button press
                print('Add button pressed');
              },
            ),
            IconButton(
              icon: Icon(Icons.rss_feed),
              // Add your desired color for the RSS feed icon
              // color: Colors.red, // Example color
              onPressed: () {
                // Handle Newsfeed button press
                print('Newsfeed button pressed');
              },
            ),
          ],
        ),
      ),
    );
  }
}
