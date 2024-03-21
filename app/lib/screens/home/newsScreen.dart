import 'package:app/widgets/appTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // Dummy news data for demonstration
  List<Map<String, dynamic>> newsData = [
    {
      'title': 'Breaking News',
      'source': 'CNN',
      'image': '../assets/images/sample.jpg',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    },
    {
      'title': 'Sports Update',
      'source': 'ESPN',
      'image': '../assets/images/sample.jpg',
      'description':
          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    },
    {
      'title': 'Tech Insights',
      'source': 'TechCrunch',
      'image': '../assets/images/sample.jpg',
      'description':
          'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        backgroundColor: AppTheme.bgColor,
        title: Text('News', style: TextStyle(color: AppTheme.lightGreyColor)),
        iconTheme: IconThemeData(color: AppTheme.lightGreyColor),
      ),
      body: ListView.builder(
        itemCount: newsData.length,
        itemBuilder: (context, index) {
          return _buildNewsItem(index);
        },
      ),
    );
  }

  Widget _buildNewsItem(int index) {
    return GestureDetector(
      onTap: () {
        // Handle news item tap
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppTheme.greyColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            // BoxShadow(
            //   color: AppTheme.lightGreyColor,
            //   spreadRadius: 2,
            //   blurRadius: 5,
            //   offset: Offset(0, 3),
            // ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                newsData[index]['image'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              newsData[index]['title'],
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              'Source: ${newsData[index]['source']}',
              style: TextStyle(
                color: AppTheme.lightGreyColor,
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              newsData[index]['description'],
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.0,
                color: AppTheme.lightGreyColor,
              ),
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.share),
                  color: AppTheme.lightGreyColor,
                  onPressed: () {
                    // Handle share button
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
