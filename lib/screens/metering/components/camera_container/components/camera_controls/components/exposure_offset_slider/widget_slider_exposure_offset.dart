import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/shared/ruler_slider/widget_slider_ruler.dart';
import 'package:lightmeter/utils/to_string_signed.dart';

class ExposureOffsetSlider extends StatelessWidget {
  final RangeValues range;
  final double value;
  final ValueChanged<double> onChanged;

  const ExposureOffsetSlider({
    required this.range,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RulerSlider(
      range: range,
      value: value,
      onChanged: onChanged,
      icon: Icons.light_mode,
      defaultValue: 0,
      rulerValueAdapter: (value) => value.toStringSignedAsFixed(0),
      valueAdapter: (value) => S.of(context).evValue(value.toStringSignedAsFixed(1)),
    );
  }
}
