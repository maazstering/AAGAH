import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnimatedLikeButton extends StatefulWidget {
  @override
  _AnimatedLikeButtonState createState() => _AnimatedLikeButtonState();
}

class _AnimatedLikeButtonState extends State<AnimatedLikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isLiked = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleLikeButtonPressed() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _animationController.forward(from: 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleLikeButtonPressed,
      child: ScaleTransition(
        scale: _animation,
        child: Icon(
          _isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          color: _isLiked ? Colors.red : Colors.grey,
        ),
      ),
    );
  }
}
