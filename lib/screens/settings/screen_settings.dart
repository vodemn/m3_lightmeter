import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/about/widget_settings_section_about.dart';
import 'package:lightmeter/screens/settings/components/camera/widget_settings_section_camera.dart';
import 'package:lightmeter/screens/settings/components/general/widget_settings_section_general.dart';
import 'package:lightmeter/screens/settings/components/lightmeter_pro/widget_settings_section_lightmeter_pro.dart';
import 'package:lightmeter/screens/settings/components/metering/widget_settings_section_metering.dart';
import 'package:lightmeter/screens/settings/components/theme/widget_settings_section_theme.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:lightmeter/utils/context_utils.dart';

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
        title: Text(S.of(context).settings),
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                if (!context.isPro) const LightmeterProSettingsSection(),
                const MeteringSettingsSection(),
                const CameraSettingsSection(),
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
