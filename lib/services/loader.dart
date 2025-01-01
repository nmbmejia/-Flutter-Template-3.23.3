import 'package:Acorn/services/app_colors.dart';
import 'package:flutter/material.dart';

class LoaderWidget extends StatefulWidget {
  const LoaderWidget({super.key});

  @override
  State<LoaderWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: const CircularProgressIndicator(
        strokeWidth: 3.0,
        color: AppColors.whiteColor,
      ),
    );
  }
}
