import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:provider/provider.dart';

import 'components/measure_button/widget_button_measure.dart';
import 'components/secondary_button/widget_button_secondary.dart';

class MeteringBottomControls extends StatelessWidget {
  final VoidCallback? onSwitchEvSourceType;
  final VoidCallback onMeasure;
  final VoidCallback onSettings;

  const MeteringBottomControls({
    required this.onSwitchEvSourceType,
    required this.onMeasure,
    required this.onSettings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(Dimens.borderRadiusL),
        topRight: Radius.circular(Dimens.borderRadiusL),
      ),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimens.paddingL),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (onSwitchEvSourceType != null)
                  Expanded(
                    child: MeteringSecondaryButton(
                      onPressed: onSwitchEvSourceType!,
                      icon: context.watch<EvSourceType>() != EvSourceType.camera
                          ? Icons.camera_rear
                          : Icons.wb_incandescent,
                    ),
                  )
                else
                  const Spacer(),
                MeteringMeasureButton(
                  onTap: onMeasure,
                ),
                Expanded(
                  child: MeteringSecondaryButton(
                    onPressed: onSettings,
                    icon: Icons.settings,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
