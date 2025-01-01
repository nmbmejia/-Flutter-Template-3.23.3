import 'package:Acorn/services/app_colors.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';

class CustomDatepicker extends StatefulWidget {
  const CustomDatepicker({super.key, this.onChanged});

  final Function(dynamic value)? onChanged;

  @override
  State<CustomDatepicker> createState() => _CustomDatepickerState();
}

class _CustomDatepickerState extends State<CustomDatepicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          15,
        ),
        color: const Color(0xFFD9D9D9),
      ),
      width: MediaQuery.of(context).size.width * 0.85,
      child: DatePicker(
        currentDateDecoration: const BoxDecoration(),
        centerLeadingDate: true,
        leadingDateTextStyle:
            const TextStyle(color: Colors.black87, fontSize: 14),
        selectedCellDecoration: const BoxDecoration(
            color: AppColors.primaryColor, shape: BoxShape.circle),
        selectedCellTextStyle:
            const TextStyle(color: Colors.white, fontSize: 18),
        enabledCellsTextStyle:
            const TextStyle(color: Colors.black87, fontSize: 14),
        currentDateTextStyle: const TextStyle(
            color: AppColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold),
        disabledCellsTextStyle:
            const TextStyle(color: Colors.grey, fontSize: 14),
        daysOfTheWeekTextStyle:
            const TextStyle(color: Colors.grey, fontSize: 12),
        highlightColor: AppColors.primaryColor,
        splashColor: AppColors.primaryColor,
        slidersColor: Colors.black87,
        slidersSize: 14,
        padding: EdgeInsets.zero,
        minDate: DateTime(1900, 1, 1),
        maxDate: DateTime.now(),
        onDateSelected: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
      ),
    );
  }
}
