import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';

import 'components/about/widget_settings_section_about.dart';
import 'components/general/widget_settings_section_general.dart';
import 'components/metering/widget_settings_section_metering.dart';
import 'components/theme/widget_settings_section_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverScreen(
      title: S.of(context).settings,
      appBarActions: [
        IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.close),
        ),
      ],
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              const MeteringSettingsSection(),
              const GeneralSettingsSection(),
              const ThemeSettingsSection(),
              const AboutSettingsSection(),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ],
    );
  }
}
