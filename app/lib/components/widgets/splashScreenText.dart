import 'package:flutter/material.dart';

class SplashText extends StatelessWidget {
  final String text;
  final Color textColor;
  final String fontFamily;
  final double fontSize;

  const SplashText({
    super.key,
    required this.text,
    this.textColor = const Color(0xFFCCCCCC),
    this.fontFamily = 'Newsreader',
    this.fontSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontFamily: fontFamily,
        fontSize: fontSize,
      ),
    );
  }
}
