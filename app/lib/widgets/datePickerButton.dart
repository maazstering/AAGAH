import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DatePickerButton extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onChanged;

  const DatePickerButton({
    Key? key,
    required this.selectedDate,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: 343,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0.r),
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
