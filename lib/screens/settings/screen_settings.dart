import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/about/widget_settings_section_about.dart';
import 'package:lightmeter/screens/settings/components/general/widget_settings_section_general.dart';
import 'package:lightmeter/screens/settings/components/metering/widget_settings_section_metering.dart';
import 'package:lightmeter/screens/settings/components/theme/widget_settings_section_theme.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: SliverScreen(
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
      ),
    );
  }
}
