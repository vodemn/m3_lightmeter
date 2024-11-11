import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

class ReleaseNotesDialog extends StatelessWidget {
  final String version;

  const ReleaseNotesDialog({required this.version, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).whatsnew),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).changesInVersion(version),
              style: Theme.of(context).textTheme.titleSmall,
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
    try {
      return rootBundle.loadString('assets/release_notes/release_notes_en_$version.md');
    } catch (e) {
      return '';
    }
  }
}
