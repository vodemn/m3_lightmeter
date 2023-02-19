import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/shared/settings_section/widget_settings_section.dart';

import 'components/calibration/widget_list_tile_calibration.dart';
import 'components/fractional_stops/widget_list_tile_fractional_stops.dart';

class MeteringSettingsSection extends StatelessWidget {
  const MeteringSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: S.of(context).metering,
      children: const [
        StopTypeListTile(),
        CalibrationListTile(),
      ],
    );
  }
}
