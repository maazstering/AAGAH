import 'dart:convert';
import 'package:app/components/themes/appTheme.dart';
import 'package:app/components/widgets/bottomNavigationCard.dart';
import 'package:app/components/widgets/tweetTile.dart';
import 'package:app/models/tweet.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TweetListScreen extends StatefulWidget {
  @override
  _TweetListScreenState createState() => _TweetListScreenState();
}

class _TweetListScreenState extends State<TweetListScreen> {
  late Future<List<Tweet>> futureTweets;

  Future<List<Tweet>> fetchTweets() async {
    try {
      final response = await http.get(
          Uri.parse('http://127.0.0.1:5000/tweets?usernames=Khitrafficpol'));

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);

        // Logging the response for debugging
        print('Parsed JSON: $jsonResponse');

        return jsonResponse.map((tweet) => Tweet.fromJson(tweet)).toList();
      } else {
        throw Exception(
            'Failed to load tweets with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching tweets: $e');
      throw Exception('Failed to load tweets: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    futureTweets = fetchTweets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.bgColor,
        title: const Center(
          child: Text('News',
              style: TextStyle(color: AppTheme.lightGreyColor)),
        ),
        iconTheme: const IconThemeData(color: AppTheme.lightGreyColor),
      ),
      body: FutureBuilder<List<Tweet>>(
        future: futureTweets,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                Tweet tweet = snapshot.data![index];
                return RoundedListTile(
                    avatarUrl: tweet.avatar,
                    text: tweet.text,
                    date: tweet.date,
                    onTap: () {});
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load tweets'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          // Handle navigation to different screens
        },
      ),
    );
  }

  // void _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}
