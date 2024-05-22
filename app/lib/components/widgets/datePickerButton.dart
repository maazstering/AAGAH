import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DatePickerButton extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onChanged;

  const DatePickerButton({
    super.key,
    required this.selectedDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      /* width: 343.w,
      height: 54.h,
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(8.r),*/

      height: 54.h,
      width: 343.w,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        onPressed: () async {
          DateTime? datePicked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime(2005, 12, 31),
            firstDate: DateTime(1930),
            lastDate: DateTime(2005, 12, 31),
          );
          if (datePicked != null) {
            onChanged(datePicked);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                  : "Date of Birth",
              style: const TextStyle(fontFamily: "Mulish"),
            ),
            const Icon(Icons.calendar_today_outlined),
          ],
        ),
      ),
    );
  }
}
