import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

import 'package:lightmeter/screens/metering/components/bottom_controls/widget_bottom_controls.dart';

class MeteringBottomControlsProvider extends StatelessWidget {
  final double? ev;
  final bool isMetering;
  final VoidCallback? onSwitchEvSourceType;
  final VoidCallback onMeasure;
  final VoidCallback onSettings;

  const MeteringBottomControlsProvider({
    required this.ev,
    required this.isMetering,
    required this.onSwitchEvSourceType,
    required this.onMeasure,
    required this.onSettings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButtonTheme(
      data: IconButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(scheme.surface),
          elevation: const MaterialStatePropertyAll(4),
          iconColor: MaterialStatePropertyAll(scheme.onSurface),
          shadowColor: const MaterialStatePropertyAll(Colors.transparent),
          surfaceTintColor: MaterialStatePropertyAll(scheme.surfaceTint),
          fixedSize: const MaterialStatePropertyAll(Size(Dimens.grid48, Dimens.grid48)),
        ),
      ),
      child: MeteringBottomControls(
        ev: ev,
        isMetering: isMetering,
        onSwitchEvSourceType: onSwitchEvSourceType,
        onMeasure: onMeasure,
        onSettings: onSettings,
      ),
    );
  }
}
