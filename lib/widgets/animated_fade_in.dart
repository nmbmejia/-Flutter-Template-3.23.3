import 'package:Acorn/services/constants.dart';
import 'package:flutter/material.dart';

class AnimatedFadeInItem extends StatefulWidget {
  final Widget child;
  final int index;
  final int delayInMs;

  const AnimatedFadeInItem(
      {super.key,
      required this.child,
      required this.index,
      this.delayInMs = 250});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedFadeInItemState createState() => _AnimatedFadeInItemState();
}

class _AnimatedFadeInItemState extends State<AnimatedFadeInItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller, curve: Curves.fastEaseInToSlowEaseOut),
    );

    // Start the animation with a staggered delay based on the index
    Future.delayed(Duration(milliseconds: widget.index * widget.delayInMs), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
