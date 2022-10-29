import 'package:flutter/material.dart';

class FilledCircle extends StatelessWidget {
  final double size;
  final Color color;
  final Widget? child;

  const FilledCircle({
    required this.size,
    required this.color,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: SizedBox.fromSize(
        size: Size.square(size),
        child: ColoredBox(
          color: color,
          child: child,
        ),
      ),
    );
  }
}
