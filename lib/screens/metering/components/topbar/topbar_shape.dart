import 'package:flutter/material.dart';

class TopBarShape extends CustomPainter {
  final Color color;
  final Size appendixSize;
  final double radius;

  TopBarShape({
    required this.color,
    required this.appendixSize,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    final circularRadius = Radius.circular(radius);
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height - radius);
    path.arcToPoint(
      Offset(size.width - radius, size.height),
      radius: circularRadius,
    );
    path.lineTo(size.width - appendixSize.width + radius, size.height);
    path.arcToPoint(
      Offset(size.width - appendixSize.width, size.height - radius),
      radius: circularRadius,
    );
    path.lineTo(size.width - appendixSize.width, size.height - appendixSize.height + radius);
    path.arcToPoint(
      Offset(size.width - appendixSize.width - radius, size.height - appendixSize.height),
      radius: circularRadius,
      clockwise: false,
    );
    path.lineTo(radius, size.height - appendixSize.height);
    path.arcToPoint(
      Offset(0, size.height - appendixSize.height - radius),
      radius: circularRadius,
    );
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
