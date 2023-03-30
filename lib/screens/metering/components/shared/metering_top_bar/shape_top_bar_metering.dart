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
    final path = Path();
    const circularRadius = Radius.circular(Dimens.borderRadiusL);
    if (appendixHeight == 0 || appendixWidth == 0) {
      path.addRRect(
        RRect.fromLTRBAndCorners(
          0,
          0,
          size.width,
          size.height,
          bottomLeft: circularRadius,
          bottomRight: circularRadius,
        ),
      );
    } else if (appendixHeight < 0) {
      // Left side with bottom corner
      path.lineTo(0, size.height + appendixHeight - Dimens.borderRadiusL);
      path.arcToPoint(
        Offset(Dimens.borderRadiusL, size.height + appendixHeight),
        radius: circularRadius,
        clockwise: false,
      );

      // Bottom side with step
      final allowedRadius = min(appendixHeight.abs() / 2, Dimens.borderRadiusL);
      path.lineTo(appendixWidth - allowedRadius, size.height + appendixHeight);
      path.arcToPoint(
        Offset(appendixWidth, size.height + appendixHeight + allowedRadius),
        radius: circularRadius,
        clockwise: true,
      );
      path.lineTo(appendixWidth, size.height - allowedRadius);
      path.arcToPoint(
        Offset(appendixWidth + allowedRadius, size.height),
        radius: circularRadius,
        clockwise: false,
      );

      // Right side with bottom corner
      path.lineTo(size.width - Dimens.borderRadiusL, size.height);
      path.arcToPoint(
        Offset(size.width, size.height - Dimens.borderRadiusL),
        radius: circularRadius,
        clockwise: false,
      );
    } else {
      // Left side with bottom corner
      path.lineTo(0, size.height - Dimens.borderRadiusL);
      path.arcToPoint(
        Offset(Dimens.borderRadiusL, size.height),
        radius: circularRadius,
        clockwise: false,
      );

      // Bottom side with step
      final allowedRadius = min(appendixHeight.abs() / 2, Dimens.borderRadiusL);
      path.relativeLineTo(appendixWidth - allowedRadius * 2, 0);
      path.relativeArcToPoint(
        Offset(allowedRadius, -allowedRadius),
        radius: Radius.circular(allowedRadius),
        rotation: 90,
        clockwise: false,
      );
      path.relativeLineTo(0, -appendixHeight + allowedRadius * 2);
      path.relativeArcToPoint(
        Offset(allowedRadius, -allowedRadius),
        radius: Radius.circular(allowedRadius),
        rotation: 90,
        clockwise: true,
      );

      // Right side with bottom corner
      path.lineTo(size.width - Dimens.borderRadiusL, size.height - appendixHeight);
      path.arcToPoint(
        Offset(size.width, size.height - appendixHeight - Dimens.borderRadiusL),
        radius: circularRadius,
        clockwise: false,
      );
    }
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
