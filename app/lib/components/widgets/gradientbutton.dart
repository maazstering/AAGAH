import 'package:app/components/themes/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool settings; //if this button is to be used for settings page, add an icon

  const GradientButton({
    super.key,
    required this.text,
    required this.settings,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h, // Adjust height as needed
      width: double.infinity, // Expands to full width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0.r),
        gradient: const LinearGradient(
          colors: [
            AppTheme.magentaColor, // Start color
            AppTheme.lavenderColor, // End color
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (settings) ...[
              const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              SizedBox(width: 8.0.w), // Add some space between the icon and text
            ],
            Text(
              text,
              style: TextStyle(
                color: Colors.white, // White text color
                fontSize: 16.0.sp, // Adjust font size as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
