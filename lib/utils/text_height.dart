import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

double dialogTextHeight(
  BuildContext context,
  String text,
  TextStyle? style,
  double textPadding,
) =>
    textHeight(
      text,
      style,
      MediaQuery.sizeOf(context).width - Dimens.dialogMargin.horizontal - textPadding,
    );

double textHeight(
  String text,
  TextStyle? style,
  double maxWidth,
) =>
    textSize(text, style, maxWidth).height;

Size textSize(
  String text,
  TextStyle? style,
  double maxWidth,
) {
  final TextPainter titlePainter = TextPainter(
    text: TextSpan(
      text: text,
      style: style,
    ),
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: maxWidth);
  return titlePainter.size;
}
