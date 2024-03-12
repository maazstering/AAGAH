import 'package:app/widgets/appTheme.dart';
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
    );
  }

  Widget feedItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
                    'assets/images/profile.jpg'), // Use actual user image
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
                      style: TextStyle(color: Colors.grey),
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
              'assets/images/sample.jpg', // Use actual post image
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
                          color: Colors.black), // Updated for null safety
                      onPressed: () {
                        // Handle like
                      },
                    ),
                    Text('300 likes', style: TextStyle(color: Colors.black)),
                  ],
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.comment,
                      color: Colors.black), // Updated for null safety
                  onPressed: () {
                    // Handle comments
                  },
                ),
              ],
            ),
          ),
          Text(
            'View all 10 comments', // Use actual comment count
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 4.0),
          Text(
            '2 hours ago', // Use actual post time
            style: TextStyle(color: Colors.grey, fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
