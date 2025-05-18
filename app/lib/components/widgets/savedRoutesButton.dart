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
                height: 200.h,
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: const Text('Home'),
                      subtitle:
                          const Text('Address: Model Colony, Malir, Karachi'),
                      onTap: () {
                        // Handle tapping on Home
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    ),
                    ListTile(
                      title: const Text('University'),
                      subtitle: const Text('Address: IBA, Main Campus'),
                      onTap: () {
                        // Handle tapping on University
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    ),
                    ListTile(
                      title:
                          const Text('Add more locations to get updates for'),
                      trailing: const Icon(Icons.add),
                      onTap: () {
                        // Handle adding more locations
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    ),
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
