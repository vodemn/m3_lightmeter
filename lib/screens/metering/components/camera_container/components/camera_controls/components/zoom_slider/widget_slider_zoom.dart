import 'package:flutter/material.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/screens/shared/ruler_slider/widget_slider_ruler.dart';
import 'package:lightmeter/utils/double_to_zoom.dart';

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
    return RulerSlider(
      range: range,
      value: value,
      onChanged: onChanged,
      icon: Icons.search_outlined,
      defaultValue: EquipmentProfiles.selectedOf(context).lensZoom,
      rulerValueAdapter: (value) => value.toStringAsFixed(0),
      valueAdapter: (value) => value.toZoom(context),
    );
  }
}
