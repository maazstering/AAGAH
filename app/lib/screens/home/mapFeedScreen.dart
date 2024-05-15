import 'package:app/screens/home/cameraScreen.dart';
import 'package:app/screens/home/newsScreen.dart';
import 'package:app/widgets/appTheme.dart';
import 'package:app/widgets/bottomNavigationCard.dart';
import 'package:app/widgets/splashScreenText.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/home/feed.dart'; // Import your feed screen
import 'package:app/screens/home/mapScreen.dart'; // Import your map screen

class MapFeedScreen extends StatefulWidget {
  @override
  _MapFeedScreenState createState() => _MapFeedScreenState();
}

class _MapFeedScreenState extends State<MapFeedScreen> {
  bool showMap = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.lilacColor,
        title: const Center(
          child: Text(
            "Aagah",
            style:
                TextStyle(color: AppTheme.whiteColor, fontFamily: 'Newsreader'),
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            if (scrollNotification.scrollDelta! > 0) {
              // User scrolled down, expand map
              setState(() {
                showMap = true;
              });
            } else if (scrollNotification.scrollDelta! < 0) {
              // User scrolled up, show feed
              setState(() {
                showMap = false;
              });
            }
          }
          return false;
        },
        child: Stack(
          children: [
            // Map widget
            Positioned.fill(
              top: showMap ? 0.0 : -MediaQuery.of(context).size.height * 0.75,
              child: MapWidget(), // Your map widget
            ),
            // Feed widget
            // Positioned(
            //   top: showMap ? MediaQuery.of(context).size.height * 0.25 : 0.0,
            //   left: 0.0,
            //   right: 0.0,
            //   bottom: 0.0,
            //   child: FeedWidget(), // Your feed widget
            // ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2, onTap: (_) {},),
    );
  }
}
