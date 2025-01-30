import 'package:Acorn/services/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoaderWidget extends StatefulWidget {
  const LoaderWidget({super.key, this.withMargins = false});

  final bool withMargins;

  @override
  State<LoaderWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.withMargins ? const EdgeInsets.all(15) : null,
      child: LoadingAnimationWidget.progressiveDots(
        color: AppColors.whiteColor.withOpacity(0.4),
        size: 30,
      ),
    );
  }
}
