import 'package:app/widgets/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({
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
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black, // Dark theme
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
            },
          ),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.plusCircle,
              color: widget.currentIndex == 1
                  ? AppTheme.periwinkleColor
                  : AppTheme.whiteColor,
            ),
            onPressed: () {
              if (widget.currentIndex != 1) {
                widget.onTap(1);
                _playAnimation();
              }
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
