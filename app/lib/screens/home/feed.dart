import 'package:app/screens/home/comment.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/appTheme.dart';
import 'package:app/widgets/bottomNavigationCard.dart';
import 'package:app/widgets/likeButton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import the CommentPage widget

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
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 40,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.message_rounded),
            onPressed: () {
              // Message
            },
          )
        ],
      ),
      body: Container(
        color: AppTheme.bgColor,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) =>
              feedItem(index, context), // Pass context to feedItem
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation to different screens
        },
      ),
    );
  }

  Widget feedItem(int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.bgColor,
        borderRadius: BorderRadius.circular(1.0),
        border: Border.all(
          color: AppTheme.greyColor,
          width: 0.5,
        ),
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
                      'Username $index',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.lightGreyColor),
                    ),
                    Text(
                      'Location information',
                      style: TextStyle(color: AppTheme.lightGreyColor),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: AppTheme.lightGreyColor,
                ),
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
              '../assets/images/sample.jpg',
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
                    AnimatedLikeButton(),
                    Text('300 likes',
                        style: TextStyle(color: AppTheme.lightGreyColor)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to CommentPage when tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CommentPage()),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.comment, color: AppTheme.greyColor),
                      SizedBox(width: 5),
                      Text(
                        'View all 10 comments',
                        style: TextStyle(color: AppTheme.lightGreyColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            '2 hours ago',
            style: TextStyle(color: AppTheme.lightGreyColor, fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
