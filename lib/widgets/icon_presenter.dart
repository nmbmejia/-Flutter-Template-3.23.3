import 'package:flutter/material.dart';

class IconPresenter extends StatefulWidget {
  const IconPresenter({super.key, required this.icon, this.size = 28});

  final String? icon;
  final double size;

  @override
  State<IconPresenter> createState() => _IconPresenterState();
}

class _IconPresenterState extends State<IconPresenter> {
  @override
  Widget build(BuildContext context) {
    return widget.icon == null
        ? const SizedBox()
        : Image.asset(
            'assets/icon/${widget.icon}',
            width: widget.size,
            height: widget.size,
            fit: BoxFit.cover,
          );
  }
}
