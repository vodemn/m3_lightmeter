import 'package:flutter/material.dart';
import 'package:lightmeter/screens/shared/ruler_slider/widget_slider_ruler.dart';

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
    return Column(
      children: [
        const IconButton(
          icon: Icon(Icons.lock_open),
          onPressed: null,
        ),
        Expanded(
          child: RulerSlider(
            icon: Icons.search,
            range: range,
            value: value,
            onChanged: onChanged,
            rulerValueAdapter: (value) => '${value.toStringAsFixed(0)}x',
          ),
        ),
      ],
    );
  }
}
