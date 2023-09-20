import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class MeteringTopBarShape extends CustomPainter {
  final Color color;

  /// The appendix is on the left side
  /// but if appendix height is negative, then we have to make a cutout
  ///
  ///         negative                       positive
  ///   |                   |   ///   |                   |
  ///   |                   |   ///   |                   |
  ///   |                   |   ///   |                   |
  ///   |                   |   ///   |                   |
  ///   \________           |   ///   |           ________/
  ///            \          |   ///   |          /              ↑
  ///            |          |   ///   |          |              | appendix height
  ///            \__________/   ///   \__________/              ↓
  ///
  final double appendixHeight;
  final double appendixWidth;

  MeteringTopBarShape({
    required this.color,
    required this.appendixHeight,
    required this.appendixWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    late final Path path;
    if (appendixHeight == 0 || appendixWidth == 0) {
      path = _drawNoAppendix(size, Dimens.borderRadiusL);
    } else if (appendixHeight < 0) {
      path = _drawAppendixOnLeft(size, Dimens.borderRadiusL);
      canvas.scale(-1, 1);
      canvas.translate(-size.width, 0);
    } else {
      path = _drawAppendixOnLeft(size, Dimens.borderRadiusL);
    }
    canvas.drawPath(path, paint);
  }

  Path _drawNoAppendix(Size size, double bottomRadius) {
    final circularRadius = Radius.circular(bottomRadius);
    return Path()
      ..addRRect(
        RRect.fromLTRBAndCorners(
          0,
          0,
          size.width,
          size.height,
          bottomLeft: circularRadius,
          bottomRight: circularRadius,
        ),
      )
      ..close();
  }

  Path _drawAppendixOnLeft(Size size, double bottomRadius) {
    final path = Path();
    final circularRadius = Radius.circular(bottomRadius);
    final appendixHeight = this.appendixHeight.abs();

    // Left side with bottom corner
    path.lineTo(0, size.height - bottomRadius);
    path.arcToPoint(
      Offset(bottomRadius, size.height),
      radius: circularRadius,
      clockwise: false,
    );

    // Bottom side with step
    final allowedRadius = min(appendixHeight.abs() / 2, bottomRadius);
    path.lineTo(appendixWidth - allowedRadius, size.height);
    path.arcToPoint(
      Offset(appendixWidth, size.height - allowedRadius),
      radius: Radius.circular(allowedRadius),
      rotation: 90,
      clockwise: false,
    );
    path.lineTo(appendixWidth, size.height - appendixHeight + allowedRadius);
    path.arcToPoint(
      Offset(appendixWidth + allowedRadius, size.height - appendixHeight),
      radius: Radius.circular(allowedRadius),
      rotation: 90,
    );

    // Right side with bottom corner
    path.lineTo(size.width - bottomRadius, size.height - appendixHeight);
    path.arcToPoint(
      Offset(size.width, size.height - appendixHeight - bottomRadius),
      radius: circularRadius,
      clockwise: false,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
