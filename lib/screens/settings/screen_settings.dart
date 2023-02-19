import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

import 'components/about/widget_settings_section_about.dart';
import 'components/general/widget_settings_section_general.dart';
import 'components/metering/widget_settings_section_metering.dart';
import 'components/theme/widget_settings_section_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              expandedHeight: Dimens.grid168,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: const EdgeInsets.all(Dimens.paddingM),
                title: Text(
                  S.of(context).settings,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 24,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
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
      ),
    );
  }
}
