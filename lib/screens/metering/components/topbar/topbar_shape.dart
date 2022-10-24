import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class TopBarShape extends CustomPainter {
  final Color color;
  final Size appendixSize;

  TopBarShape({
    required this.color,
    required this.appendixSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    const circularRadius = Radius.circular(Dimens.borderRadiusL);
    if (appendixSize.shortestSide == 0) {
      path.addRRect(
        RRect.fromLTRBAndCorners(
          0,
          0,
          0,
          0,
          bottomLeft: circularRadius,
          bottomRight: circularRadius,
        ),
      );
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height - Dimens.borderRadiusL);
      path.arcToPoint(
        Offset(size.width - Dimens.borderRadiusL, size.height),
        radius: circularRadius,
      );
      path.lineTo(size.width - appendixSize.width + Dimens.borderRadiusL, size.height);
      path.arcToPoint(
        Offset(size.width - appendixSize.width, size.height - Dimens.borderRadiusL),
        radius: circularRadius,
      );
      path.lineTo(size.width - appendixSize.width, size.height - appendixSize.height + Dimens.borderRadiusM);
      path.arcToPoint(
        Offset(size.width - appendixSize.width - Dimens.borderRadiusM, size.height - appendixSize.height),
        radius: circularRadius,
        clockwise: false,
      );
      path.lineTo(Dimens.borderRadiusL, size.height - appendixSize.height);

      path.arcToPoint(
        Offset(0, size.height - appendixSize.height - Dimens.borderRadiusL),
        radius: circularRadius,
      );
      path.lineTo(0, 0);
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
