import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/components/measure_button/widget_button_measure.dart';
import 'package:lightmeter/screens/shared/bottom_controls_bar/widget_bottom_controls_bar.dart';

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
    return BottomControlsBar(
      left: onSwitchEvSourceType != null
          ? IconButton(
              onPressed: onSwitchEvSourceType,
              icon: Icon(
                UserPreferencesProvider.evSourceTypeOf(context) != EvSourceType.camera
                    ? Icons.camera_rear
                    : Icons.wb_incandescent,
              ),
              tooltip: UserPreferencesProvider.evSourceTypeOf(context) != EvSourceType.camera
                  ? S.of(context).tooltipUseCamera
                  : S.of(context).tooltipUseLightSensor,
            )
          : null,
      center: MeteringMeasureButton(
        ev: ev,
        ev100: ev100,
        isMetering: isMetering,
        onTap: onMeasure,
      ),
      right: IconButton(
        onPressed: onSettings,
        icon: const Icon(Icons.settings),
        tooltip: S.of(context).tooltipOpenSettings,
      ),
    );
  }
}
