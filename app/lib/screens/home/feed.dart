import 'dart:convert';
import 'package:app/widgets/variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/widgets/appTheme.dart';
import 'package:app/widgets/bottomNavigationCard.dart';
import 'package:app/widgets/likeButton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app/screens/home/comment.dart';

class FeedWidget extends StatefulWidget {
  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final uri = Uri.parse('${Variables.address}/social?isJson=true');
      final response = await http.get(uri);

      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('application/json')) {
        final jsonData = json.decode(response.body);
        setState(() {
          posts = (jsonData as List)
              .map((data) => Post.fromJson(data))
              .toList();
        });
      } else {
        print('Response is not JSON');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.bgColor,
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) => feedItem(index, context),
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
