import 'package:app/components/themes/appTheme.dart';
import 'package:app/screens/home/cameraScreen.dart';
import 'package:app/screens/home/feed.dart';
//import 'package:app/screens/news/newsScreen.dart';
import 'package:app/screens/home/profileScreen.dart';
import 'package:app/screens/news/newsScreen.dart';
import 'package:app/screens/news/tweetListScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppTheme.bgColor, // Dark theme
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.house,
              color: widget.currentIndex == 0
                  ? AppTheme.periwinkleColor
                  : AppTheme.whiteColor,
            ),
            onPressed: () {
              if (widget.currentIndex != 0) {
                widget.onTap(0);
                _playAnimation();
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FeedWidget(),
                ),
              );
            },
          ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.circlePlus,
              color: widget.currentIndex == 1
                  ? AppTheme.periwinkleColor
                  : AppTheme.whiteColor,
            ),
            onPressed: () {
              if (widget.currentIndex != 1) {
                widget.onTap(1);
                _playAnimation();
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PostingScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.newspaper, // Icon for the News button
              color: widget.currentIndex == 3 // Adjusted index for News button
                  ? AppTheme.periwinkleColor
                  : AppTheme.whiteColor,
            ),
            onPressed: () {
              if (widget.currentIndex != 3) {
                widget.onTap(3); // Adjusted index for News button
                _playAnimation();
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  //tweetscreen
                  builder: (context) => NewsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.user,
              color: widget.currentIndex == 2
                  ? AppTheme.periwinkleColor
                  : AppTheme.whiteColor,
            ),
            onPressed: () {
              if (widget.currentIndex != 2) {
                widget.onTap(2);
                _playAnimation();
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _playAnimation() {
    if (_animationController.isAnimating) return;
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
