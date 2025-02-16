import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  static Color get primaryColor =>
      Get.isDarkMode ? const Color(0xFF171717) : Colors.white;

  static Color get darkGrayColor =>
      Get.isDarkMode ? const Color(0xFF252525) : const Color(0xFFF5F5F5);

  static Color get lightGrayColor =>
      Get.isDarkMode ? const Color(0xFF3D3D3D) : const Color(0xFFE8E8E8);

  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color whiteSecondaryColor = Color(0xFFD3D3D3);
  static Color get whiteTertiaryColor =>
      Get.isDarkMode ? const Color(0xFF5F5F5F) : const Color(0xFFAAAAAA);

  static const Color secondaryColor = Color(0xFFE8A747);
  static Color tertiaryColor = const Color(0xFFFFB0B0);
  static const Color greenColor = Color.fromARGB(255, 23, 159, 52);
  static const Color pendingColor = Color(0xFF1BBB3E);
  static Color dialogColor = lightGrayColor;
  static const Color weeklyColor = Color(0xFFC7BC59);
  static const Color yearlyColor = Color(0xFFE43F49);
  static const Color redColor = Colors.red;
}
