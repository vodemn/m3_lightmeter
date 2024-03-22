import 'package:flutter/material.dart';
import 'package:lightmeter/screens/shared/ruler_slider/widget_slider_ruler.dart';

class ZoomSlider extends RulerSlider {
  ZoomSlider({
    required super.range,
    required super.value,
    required super.onChanged,
    super.key,
  }) : super(
          icon: Icons.search,
          defaultValue: range.start,
          rulerValueAdapter: (value) => value.toStringAsFixed(0),
          valueAdapter: (value) => 'x${value.toStringAsFixed(1)}',
        );
}
