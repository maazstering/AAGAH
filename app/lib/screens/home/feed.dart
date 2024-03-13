import 'package:app/widgets/appTheme.dart';
import 'package:app/widgets/bottomNavigationCard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:antd_flutter/antd_flutter.dart';
// Make sure you add this package to your pubspec.yaml

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: AppTheme.lightGreyColor),
          backgroundColor: AppTheme.bgColor,
          centerTitle: true,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  // Handle menu button press
                  print('Menu button pressed');
                },
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 40,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                // Handle add new post
              },
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                // Handle messages screen
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: 10, // Use actual data length here
          itemBuilder: (context, index) => feedItem(index),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 0, // Assuming this is the feed screen
          onTap: (index) {
            // Handle navigation to different screens
            // You may want to use Navigator to push/pop screens here
          },
        ));
  }

  Widget feedItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyColor,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                    '../assets/images/profile.jpg'), // Use actual user image
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username $index', // Use actual username
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Location information', // Use actual location
                      style: TextStyle(color: AppTheme.greyColor),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  // Handle more options
                },
              ),
            ],
          ),
          SizedBox(height: 8.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset(
              '../assets/images/sample.jpg', // Use actual post image
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(FontAwesomeIcons.heart,
                          color: AppTheme
                              .periwinkleColor), // Updated for null safety
                      onPressed: () {
                        // Handle like
                      },
                    ),
                    Text('300 likes', style: TextStyle(color: Colors.black)),
                  ],
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.comment,
                      color: AppTheme.greyColor), // Updated for null safety
                  onPressed: () {
                    // Handle comments
                  },
                ),
              ],
            ),
          ),
          Text(
            'View all 10 comments', // Use actual comment count
            style: TextStyle(color: AppTheme.greyColor),
          ),
          SizedBox(height: 4.0),
          Text(
            '2 hours ago', // Use actual post time
            style: TextStyle(color: AppTheme.greyColor, fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
