import 'dart:convert';
import 'package:app/widgets/variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/widgets/appTheme.dart';
import 'package:app/widgets/bottomNavigationCard.dart';
import 'package:app/widgets/likeButton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app/screens/home/comment.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

// Future<void> fetchData() async {
//   try {
//     final response = await http.get(Uri.parse(Variables.address+'/social'));
//     if (response.statusCode == 200) {
//       setState(() {
//         posts = (json.decode(response.body) as List)
//             .map((data) => Post.fromJson(data))
//             .toList();
//       });
//     } else {
//       throw Exception('Failed to load posts: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error fetching data: $e');
//     // Handle error, e.g., display error message to the user
//   }
// }
void fetchData() async {
  try {
    final uri = Uri.parse('${Variables.address}/social?isJson=true');
    final response = await http.get(uri);
    
    // Print the response headers
    print('Response Headers: ${response.headers}');
    
    // Check the Content-Type header
    final contentType = response.headers['content-type'];
    if (contentType != null && contentType.contains('application/json')) {
      // Response is JSON, parse it
      final jsonData = json.decode(response.body);
      // Process the JSON data
    } else {
      // Response is not JSON, handle accordingly
      print('Response is not JSON');
    }
  } catch (e) {
    print('Error fetching data: $e');
    // Handle error, e.g., display error message to the user
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.bgColor,
        centerTitle: true,
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 12.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: AppBar().preferredSize.height - 16.0,
                ),
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
          itemCount: posts.length,
          itemBuilder: (context, index) => feedItem(index, context),
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
    final post = posts[index];
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
                backgroundImage: AssetImage(post.userImage),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightGreyColor,
                      ),
                    ),
                    Text(
                      post.location,
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
          SizedBox(
            height: 10,
          ),
          Text(
            post.content,
            style: TextStyle(color: AppTheme.lightGreyColor),
          ),
          SizedBox(height: 8.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.network(
              post.imageUrl,
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
                    Text(
                      '${post.likes} likes',
                      style: TextStyle(color: AppTheme.lightGreyColor),
                    ),
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
                        'View all ${post.comments} comments',
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
            post.timeAgo,
            style: TextStyle(color: AppTheme.lightGreyColor, fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}

class Post {
  final String userImage;
  final String username;
  final String location;
  final String content;
  final String imageUrl;
  final int likes;
  final int comments;
  final String timeAgo;

  Post({
    required this.userImage,
    required this.username,
    required this.location,
    required this.content,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.timeAgo,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userImage: json['userImage'],
      username: json['username'],
      location: json['location'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      likes: json['likes'],
      comments: json['comments'],
      timeAgo: json['timeAgo'],
    );
  }
}
