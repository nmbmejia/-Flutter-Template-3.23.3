import 'package:flutter/material.dart';
import 'package:Acorn/services/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeService {
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.primaryColor,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.secondaryColor,
          secondary: AppColors.secondaryColor,
        ),
        textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
      );

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: AppColors.secondaryColor,
          secondary: AppColors.secondaryColor,
        ),
        textTheme: GoogleFonts.latoTextTheme(ThemeData.light().textTheme),
      );
}
