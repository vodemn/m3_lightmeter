import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/shared/centered_slider/widget_slider_centered.dart';
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimens.grid8),
                child: _Ruler(
                  range.start,
                  range.end,
                ),
              ),
              CenteredSlider(
                isVertical: true,
                icon: const Icon(Icons.light_mode),
                value: value,
                min: range.start,
                max: range.end,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Ruler extends StatelessWidget {
  final double min;
  final double max;

  const _Ruler(this.min, this.max);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        (max - min + 1).toInt(),
        (index) {
          final bool showValue = index % 2 == 0.0 || index == 0.0;
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (showValue)
                Text(
                  (index + min).toStringSigned(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              const SizedBox(width: Dimens.grid8),
              ColoredBox(
                color: Theme.of(context).colorScheme.onBackground,
                child: SizedBox(
                  height: 1,
                  width: showValue ? Dimens.grid16 : Dimens.grid8,
                ),
              ),
              const SizedBox(width: Dimens.grid8),
            ],
          );
        },
      ).reversed.toList(),
    );
  }
}
