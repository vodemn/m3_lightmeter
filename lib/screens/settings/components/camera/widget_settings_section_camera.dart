import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/camera/camera_features/widget_list_tile_camera_features.dart';
import 'package:lightmeter/screens/settings/components/camera/logbook/widget_list_tile_logbook.dart';
import 'package:lightmeter/screens/settings/components/shared/settings_section/widget_settings_section.dart';

class CameraSettingsSection extends StatelessWidget {
  const CameraSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: S.of(context).camera,
      children: const [
        LogbookListTile(),
        CameraFeaturesListTile(),
      ],
    );
  }
}
