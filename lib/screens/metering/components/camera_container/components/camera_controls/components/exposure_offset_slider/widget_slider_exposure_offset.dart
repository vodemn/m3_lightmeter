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
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.sync),
          onPressed: value != 0.0 ? () => onChanged(0.0) : null,
          tooltip: S.of(context).tooltipResetToZero,
        ),
        Expanded(
          child: RulerSlider(
            icon: Icons.light_mode,
            range: range,
            value: value,
            onChanged: onChanged,
            rulerValueAdapter: (value) => value.toStringSignedAsFixed(0),
          ),
        ),
      ],
    );
  }
}
