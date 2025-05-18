import 'dart:convert';
import 'package:app/components/themes/appTheme.dart';
import 'package:app/components/widgets/bottomNavigationCard.dart';
import 'package:app/models/tweet.dart'; // Ensure this import is used
import 'package:app/screens/news/trafficIncident.dart';
import 'package:app/screens/news/trafficInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<Tweet>> futureTweets;

  Future<List<Tweet>> loadTweetsFromAssets() async {
    try {
      final String response =
          await rootBundle.loadString('assets/response.json');
      final List<dynamic> data = json.decode(response) as List<dynamic>;

      // Logging the response for debugging
      print('Parsed JSON: $data');

      return data
          .map((tweet) => Tweet.fromJson(tweet as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error occurred while loading tweets: $e');
      throw Exception('Failed to load tweets: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    futureTweets = loadTweetsFromAssets();
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load tweets'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No tweets found'));
                } else {
                  final tweets = snapshot.data!;
                  return ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (context, index) {
                      final tweet = tweets[index];
                      return RoundedListTile(
                        avatarUrl: tweet.avatar!,
                        text: tweet.text!,
                        date: tweet.date!,
                        onTap: () {},
                      );
                    },
                  );
                }
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

  const RoundedListTile({super.key, 
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
                  style: const TextStyle(
                    color: AppTheme.lightGreyColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              text,
              style: const TextStyle(
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
