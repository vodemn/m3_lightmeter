import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/about/components/report_issue/widget_list_tile_report_issue.dart';
import 'package:lightmeter/screens/settings/components/about/components/restore_purchases/widget_list_tile_restore_purchases.dart';
import 'package:lightmeter/screens/settings/components/about/components/source_code/widget_list_tile_source_code.dart';
import 'package:lightmeter/screens/settings/components/about/components/version/widget_list_tile_version.dart';
import 'package:lightmeter/screens/settings/components/about/components/write_email/widget_list_tile_write_email.dart';
import 'package:lightmeter/screens/settings/components/shared/settings_section/widget_settings_section.dart';
import 'package:lightmeter/utils/context_utils.dart';

class AboutSettingsSection extends StatelessWidget {
  const AboutSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: S.of(context).about,
      children: [
        const SourceCodeListTile(),
        const ReportIssueListTile(),
        const WriteEmailListTile(),
        const VersionListTile(),
        if (context.isPro) const RestorePurchasesListTile(),
      ],
    );
  }
}
