import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:flutter/material.dart';

class ClickableLegends extends StatefulWidget {
  const ClickableLegends({super.key});

  @override
  State<ClickableLegends> createState() => _ClickableLegendsState();
}

class _ClickableLegendsState extends State<ClickableLegends> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.weeklyColor,
              ),
            ),
            HorizSpace.eight(),
            Custom.body1('Weekly'),
            HorizSpace.ten(),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.greenColor,
              ),
            ),
            HorizSpace.eight(),
            Custom.body1('Monthly'),
            HorizSpace.ten(),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.yearlyColor,
              ),
            ),
            HorizSpace.eight(),
            Custom.body1('Yearly'),
          ],
        )
      ],
    );
  }
}
