import 'package:app/components/themes/appTheme.dart';
import 'package:flutter/material.dart';

class RoundedListTile extends StatelessWidget {
  final String avatarUrl;
  final String text;
  final String date;
  final VoidCallback onTap;

  const RoundedListTile({
    required this.avatarUrl,
    required this.text,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Container(
        decoration: BoxDecoration(
            color: AppTheme.mediumGreyColor,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: AppTheme.greyColor.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: AppTheme.whiteColor, width: 2), // Add white border
          ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
            ),
            title: Text(
              "${text} \n",
              style: const TextStyle(color: AppTheme.whiteColor),
            ),
            subtitle:
                Text(date, style: const TextStyle(color: AppTheme.whiteColor, fontWeight: FontWeight.bold),),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
