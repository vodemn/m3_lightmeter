import 'package:flutter/widgets.dart';

extension TextLineHeight on TextStyle {
  double get lineHeight => fontSize! * height!;
}
