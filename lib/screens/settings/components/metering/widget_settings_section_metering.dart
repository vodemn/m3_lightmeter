import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/metering/components/calibration/widget_list_tile_calibration.dart';
import 'package:lightmeter/screens/settings/components/metering/components/camera_features/widget_list_tile_camera_features.dart';
import 'package:lightmeter/screens/settings/components/metering/components/equipment_profiles/widget_list_tile_equipment_profiles.dart';
import 'package:lightmeter/screens/settings/components/metering/components/films/widget_list_tile_films.dart';
import 'package:lightmeter/screens/settings/components/metering/components/fractional_stops/widget_list_tile_fractional_stops.dart';
import 'package:lightmeter/screens/settings/components/metering/components/metering_screen_layout/widget_list_tile_metering_screen_layout.dart';
import 'package:lightmeter/screens/settings/components/metering/components/show_ev_100/widget_list_tile_show_ev_100.dart';
import 'package:lightmeter/screens/settings/components/shared/settings_section/widget_settings_section.dart';

class MeteringSettingsSection extends StatelessWidget {
  const MeteringSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: S.of(context).metering,
      children: const [
        StopTypeListTile(),
        CalibrationListTile(),
        ShowEv100ListTile(),
        MeteringScreenLayoutListTile(),
        EquipmentProfilesListTile(),
        FilmsListTile(),
        CameraFeaturesListTile(),
      ],
    );
  }
}
