import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/shared/release_notes_dialog/widget_dialog_release_notes.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionListTile extends StatelessWidget {
  const VersionListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) => ListTile(
        leading: const Icon(Icons.info_outline),
        title: Text(S.of(context).version),
        onTap: snapshot.data != null
            ? () => showDialog(
                  context: context,
                  builder: (_) => ReleaseNotesDialog(version: snapshot.data!.version),
                )
            : null,
        trailing: snapshot.data != null
            ? Text(S.of(context).versionNumber(snapshot.data!.version, snapshot.data!.buildNumber))
            : const SizedBox.shrink(),
      ),
    );
  }
}
