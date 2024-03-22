import 'package:flutter/material.dart';
import 'package:lightmeter/screens/shared/ruler_slider/widget_slider_ruler.dart';
import 'package:lightmeter/utils/to_string_signed.dart';

class ExposureOffsetSlider extends RulerSlider {
  ExposureOffsetSlider({
    required super.range,
    required super.value,
    required super.onChanged,
    super.key,
  }) : super(
          icon: Icons.light_mode,
          defaultValue: 0,
          rulerValueAdapter: (value) => value.toStringSignedAsFixed(0),
          valueAdapter: (value) => value.toStringSignedAsFixed(1),
        );
}
