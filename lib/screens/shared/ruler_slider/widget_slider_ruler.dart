import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/shared/centered_slider/widget_slider_centered.dart';

class RulerSlider extends StatelessWidget {
  final IconData icon;
  final RangeValues range;
  final double value;
  final double defaultValue;
  final ValueChanged<double> onChanged;
  final String Function(double value) rulerValueAdapter;
  final String Function(double value) valueAdapter;

  const RulerSlider({
    required this.icon,
    required this.range,
    required this.value,
    required this.defaultValue,
    required this.onChanged,
    required this.rulerValueAdapter,
    required this.valueAdapter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          valueAdapter(value),
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: Dimens.grid4),
        Expanded(
          child: Row(
            children: [
              _Ruler(
                range.start,
                range.end,
                rulerValueAdapter,
              ),
              CenteredSlider(
                isVertical: true,
                icon: Icon(icon),
                value: value,
                min: range.start,
                max: range.end,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.sync),
          onPressed: value != defaultValue ? () => onChanged(defaultValue) : null,
          tooltip: S.of(context).tooltipResetToZero,
        ),
      ],
    );
  }
}

class _Ruler extends StatelessWidget {
  final double min;
  final double max;
  final String Function(double value) rulerValueAdapter;
  late final int mainTicksCount = (max - min + 1).toInt();
  late final int itemsCount = mainTicksCount * 2 - 1;

  _Ruler(
    this.min,
    this.max,
    this.rulerValueAdapter,
  );

  @override
  Widget build(BuildContext context) {
    final mainTicksFontSize = Theme.of(context).textTheme.bodySmall!.fontSize!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool showAllMainTicks =
            mainTicksFontSize * mainTicksCount + (1 * mainTicksCount - 1) <= constraints.maxHeight;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: (Dimens.cameraSliderHandleArea - mainTicksFontSize) / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              itemsCount,
              (index) {
                final bool isMainTick = index % 2 == 0.0;
                if (!showAllMainTicks && !isMainTick) {
                  return const SizedBox();
                }
                final bool showValue = (index % (showAllMainTicks ? 2 : 4) == 0.0);
                return SizedBox(
                  height: index == itemsCount - 1 || showValue ? mainTicksFontSize : 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (showValue)
                        Text(
                          rulerValueAdapter(index / 2 + min),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      const SizedBox(width: Dimens.grid4),
                      ColoredBox(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: SizedBox(
                          height: 1,
                          width: isMainTick ? Dimens.grid8 : Dimens.grid4,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).reversed.toList(),
          ),
        );
      },
    );
  }
}
