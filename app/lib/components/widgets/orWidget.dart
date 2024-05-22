import 'package:app/components/themes/appTheme.dart';
import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  final double thickness;
  final Color color;
  final double spaceBetweenLines;

  const OrDivider({
    super.key,
    this.thickness = 0,
    this.color = AppTheme.greyColor,
    this.spaceBetweenLines = 18,
  });

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
