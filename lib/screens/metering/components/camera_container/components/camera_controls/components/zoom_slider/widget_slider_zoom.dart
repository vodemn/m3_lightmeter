import 'package:flutter/material.dart';
import 'package:lightmeter/screens/shared/centered_slider/widget_slider_centered.dart';

class ZoomSlider extends StatelessWidget {
  final RangeValues range;
  final double value;
  final ValueChanged<double> onChanged;

  const ZoomSlider({
    required this.range,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CenteredSlider(
      icon: const Icon(Icons.search),
      value: value,
      min: range.start,
      max: range.end,
      onChanged: onChanged,
    );
  }
}
