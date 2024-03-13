import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'appTheme.dart';

class OrDivider extends StatelessWidget {
  final double thickness;
  final Color color;
  final double spaceBetweenLines;

  OrDivider({
    Key? key,
    this.thickness = 0,
    this.color = AppTheme.greyColor,
    this.spaceBetweenLines = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            thickness: thickness,
            color: color,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spaceBetweenLines),
          child: const Text(
            'or',
            style: TextStyle(
              color: AppTheme.whiteColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: thickness,
            color: color,
          ),
        ),
      ],
    );
  }
}
