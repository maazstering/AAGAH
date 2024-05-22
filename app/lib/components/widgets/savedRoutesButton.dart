import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../themes/appTheme.dart';

class SavedRoutesButton extends StatelessWidget {
  const SavedRoutesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h, // Adjust the height as needed  
      width: 343.w,
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextButton(
        onPressed: () {
          // Show the bottom sheet
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 100.h,
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: const Text('Item 1'),
                      onTap: () {
                        // Handle tapping on item 1
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    ),
                    ListTile(
                      title: const Text('Item 2'),
                      onTap: () {
                        // Handle tapping on item 2
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    ),
                    // Add more list items as needed
                  ],
                ),
              );
            },
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Saved Routes', style: TextStyle(fontFamily: 'Mulish')),
            Icon(Icons.arrow_drop_down), // Add the icon here
          ],
        ),
      ),
    );
  }
}
