import 'package:app/widgets/appTheme.dart';
import 'package:flutter/material.dart';

class Feed extends StatelessWidget {
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
            SizedBox(
                width: 16), // Adjust the space between the icon and the logo
            Image.asset(
              '../assets/images/logo.png',
              height: 40,
            ),
          ],
        ),
        backgroundColor: AppTheme.bgColor,
      ),
      body: ListView.builder(
        itemCount: 5, // Replace with actual data length
        itemBuilder: (context, index) => feedItem(index),
      ),
    );
  }

  Widget feedItem(int index) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.grey[200], // Set background color to light grey
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User information Row
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('../assets/images/profile.jpg'),
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username $index', // Placeholder for username
                    style: TextStyle(
                        color: Colors.black), // Set text color to black
                  ),
                  Text(
                    'Location information',
                    style: TextStyle(
                        color: Colors.grey[600]), // Set text color to grey
                  ),
                ],
              ),
            ],
          ),

          // Sample photo with caption
          Container(
            margin: EdgeInsets.only(top: 8.0), // Add some margin
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    '../assets/images/sample.jpg', // Replace with actual image path
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    'This is a sample caption for the post.',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          // Action buttons (like, comment, share)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      // Handle like button press
                      print('Like button pressed');
                    },
                  ),
                  Text('300'), // Placeholder for like count
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.comment, color: Colors.blue),
                    onPressed: () {
                      // Handle comment button press
                      print('Comment button pressed');
                    },
                  ),
                  Text('10'), // Placeholder for comment count
                ],
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  // Handle share button press
                  print('Share button pressed');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
