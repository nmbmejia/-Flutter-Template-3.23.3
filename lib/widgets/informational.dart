import 'package:Acorn/services/app_colors.dart';
import 'package:Acorn/services/custom_text.dart';
import 'package:Acorn/services/spacings.dart';
import 'package:flutter/material.dart';

Widget informationalBanner(String text) {
  return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.whiteColor.withOpacity(0.8),
            size: 20,
          ),
          HorizSpace.eight(),
          Custom.body2(text,
              isBold: false, color: AppColors.whiteColor.withOpacity(0.8)),
        ],
      ));
}
