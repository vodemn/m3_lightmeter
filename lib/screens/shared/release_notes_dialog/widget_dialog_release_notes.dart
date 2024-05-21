import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ReleaseNotesDialog extends StatelessWidget {
  const ReleaseNotesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).whatsnew),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) => Text(
                S.of(context).changesInVersion(snapshot.data?.version ?? ''),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: Dimens.grid8),
            FutureBuilder<String>(
              future: loadReleaseNotes(context),
              builder: (context, snapshot) => Text(snapshot.data ?? ''),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(S.of(context).close),
        ),
      ],
    );
  }

  Future<String> loadReleaseNotes(BuildContext context) async {
    String path(String locale) => 'assets/release_notes/release_notes_$locale.md';

    try {
      return rootBundle.loadString(path(UserPreferencesProvider.localeOf(context).name));
    } catch (e) {
      return rootBundle.loadString(path('en'));
    }
  }
}
