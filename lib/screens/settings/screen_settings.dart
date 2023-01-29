import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

import 'components/calibration/widget_list_tile_calibration.dart';
import 'components/haptics/provider_list_tile_haptics.dart';
import 'components/primary_color/widget_list_tile_primary_color.dart';
import 'components/report_issue/widget_list_tile_report_issue.dart';
import 'components/shared/settings_section/widget_settings_section.dart';
import 'components/source_code/widget_list_tile_source_code.dart';
import 'components/dynamic_color/widget_list_tile_dynamic_color.dart';
import 'components/theme_type/widget_list_tile_theme_type.dart';
import 'components/version/widget_list_tile_version.dart';
import 'components/fractional_stops/widget_list_tile_fractional_stops.dart';
import 'components/write_email/widget_list_tile_write_email.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
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
                <SettingsSection>[
                  SettingsSection(
                    title: S.of(context).metering,
                    children: const [
                      StopTypeListTile(),
                      CalibrationListTile(),
                    ],
                  ),
                  SettingsSection(
                    title: S.of(context).general,
                    children: const [
                      HapticsListTileProvider(),
                    ],
                  ),
                  SettingsSection(
                    title: S.of(context).theme,
                    children: const [
                      ThemeTypeListTile(),
                      PrimaryColorListTile(),
                      DynamicColorListTile(),
                    ],
                  ),
                  SettingsSection(
                    title: S.of(context).about,
                    children: const [
                      SourceCodeListTile(),
                      ReportIssueListTile(),
                      WriteEmailListTile(),
                      VersionListTile(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
