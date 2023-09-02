import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/about/widget_settings_section_about.dart';
import 'package:lightmeter/screens/settings/components/general/widget_settings_section_general.dart';
import 'package:lightmeter/screens/settings/components/metering/widget_settings_section_metering.dart';
import 'package:lightmeter/screens/settings/components/theme/widget_settings_section_theme.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SettingsInteractorProvider.of(context).disableVolumeHandling();
  }

  @override
  void deactivate() {
    SettingsInteractorProvider.of(context).restoreVolumeHandling();
    super.deactivate();
  }

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
          SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom)),
        ],
      ),
    );
  }
}
