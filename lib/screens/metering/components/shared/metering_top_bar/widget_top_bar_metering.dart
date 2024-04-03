import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/shared/metering_top_bar/shape_top_bar_metering.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/widget_container_readings.dart';

class MeteringTopBar extends StatelessWidget {
  final ReadingsContainer readingsContainer;
  final double appendixHeight;
  final Widget? preview;

  const MeteringTopBar({
    required this.readingsContainer,
    this.preview,
    this.appendixHeight = 0.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MeteringTopBarShape(
        color: Theme.of(context).colorScheme.surface,
        appendixWidth: MediaQuery.of(context).size.width / 2 - Dimens.grid8 / 2 + Dimens.paddingM,
        appendixHeight: appendixHeight,
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.paddingM),
        child: SafeArea(
          bottom: false,
          child: MediaQuery(
            data: MediaQuery.of(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: readingsContainer),
                if (preview != null) ...[
                  const SizedBox(width: Dimens.grid8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(Dimens.borderRadiusM)),
                      child: preview,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
