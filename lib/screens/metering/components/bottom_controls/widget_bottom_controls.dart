import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/components/measure_button/widget_button_measure.dart';

class MeteringBottomControls extends StatelessWidget {
  final double? ev;
  final double? ev100;
  final bool isMetering;
  final VoidCallback? onSwitchEvSourceType;
  final VoidCallback onMeasure;
  final VoidCallback onSettings;

  const MeteringBottomControls({
    required this.ev,
    required this.ev100,
    required this.isMetering,
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
                    child: Center(
                      child: IconButton(
                        onPressed: onSwitchEvSourceType,
                        icon: Icon(
                          UserPreferencesProvider.evSourceTypeOf(context) != EvSourceType.camera
                              ? Icons.camera_rear
                              : Icons.wb_incandescent,
                        ),
                        tooltip:
                            UserPreferencesProvider.evSourceTypeOf(context) != EvSourceType.camera
                                ? S.of(context).tooltipUseCamera
                                : S.of(context).tooltipUseLightSensor,
                      ),
                    ),
                  )
                else
                  const Spacer(),
                MeteringMeasureButton(
                  ev: ev,
                  ev100: ev100,
                  isMetering: isMetering,
                  onTap: onMeasure,
                ),
                Expanded(
                  child: Center(
                    child: IconButton(
                      onPressed: onSettings,
                      icon: const Icon(Icons.settings),
                      tooltip: S.of(context).tooltipOpenSettings,
                    ),
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
