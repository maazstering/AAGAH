import 'dart:convert';
import 'package:app/components/themes/appTheme.dart';
import 'package:app/components/widgets/bottomNavigationCard.dart';
import 'package:app/components/widgets/tweetTile.dart';
import 'package:app/models/tweet.dart';
import 'package:app/screens/news/trafficIncident.dart';
import 'package:app/screens/news/trafficInfo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
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
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        backgroundColor: AppTheme.bgColor,
        title: const Text('News',
            style: TextStyle(color: AppTheme.lightGreyColor)),
        iconTheme: const IconThemeData(color: AppTheme.lightGreyColor),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TrafficIncidentsScreen()),
                );
              },
              child: const Text('Get Unfiltered Traffic Incident Data'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrafficInfoScreen()),
                );
              },
              child: const Text('Get Traffic Info'),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Tweet>>(
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
                        onTap: () {},
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load tweets'));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          // Handle navigation to different screens
        },
      ),
    );
  }
}

class RoundedListTile extends StatelessWidget {
  final String avatarUrl;
  final String text;
  final String date;
  final VoidCallback onTap;

  const RoundedListTile({
    required this.avatarUrl,
    required this.text,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppTheme.greyColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 2,
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
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                const SizedBox(width: 10.0),
                Text(
                  date,
                  style: TextStyle(
                    color: AppTheme.lightGreyColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
                color: AppTheme.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Tweet {
  final String avatar;
  final String text;
  final String date;

  Tweet({required this.avatar, required this.text, required this.date});

  factory Tweet.fromJson(Map<String, dynamic> json) {
    return Tweet(
      avatar: json['avatar'] as String,
      text: json['text'] as String,
      date: json['date'] as String,
    );
  }
}
