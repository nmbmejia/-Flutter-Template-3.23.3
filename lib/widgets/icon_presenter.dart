import 'package:flutter/material.dart';

class IconPresenter extends StatefulWidget {
  const IconPresenter(
      {super.key,
      required this.icon,
      this.color,
      this.size = 28,
      this.enableAnimation = false});

  final String? icon;
  final double size;
  final Color? color;
  final bool enableAnimation;

  @override
  State<IconPresenter> createState() => _IconPresenterState();
}

class _IconPresenterState extends State<IconPresenter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    // Define fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Define scale animation
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Define rotation animation
    _rotationAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Start the animation
    widget.enableAnimation ? _controller.forward() : null;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.icon == null
        ? const SizedBox()
        : widget.enableAnimation
            ? AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotationAnimation.value * 2 * 3.1416,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/icon/${widget.icon}',
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.contain,
                  color: widget.color,
                ),
              )
            : Image.asset(
                'assets/icon/${widget.icon}',
                width: widget.size,
                height: widget.size,
                fit: BoxFit.contain,
                color: widget.color,
              );
  }
}
