import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/shared/settings_section/widget_settings_section.dart';

import 'components/report_issue/widget_list_tile_report_issue.dart';
import 'components/source_code/widget_list_tile_source_code.dart';
import 'components/version/widget_list_tile_version.dart';
import 'components/write_email/widget_list_tile_write_email.dart';

class AboutSettingsSection extends StatelessWidget {
  const AboutSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: S.of(context).about,
      children: const [
        SourceCodeListTile(),
        ReportIssueListTile(),
        WriteEmailListTile(),
        VersionListTile(),
      ],
    );
  }
}
