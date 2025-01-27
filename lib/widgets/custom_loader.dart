import 'package:Acorn/services/app_colors.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 1,
        valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
      ),
    );
  }
}
