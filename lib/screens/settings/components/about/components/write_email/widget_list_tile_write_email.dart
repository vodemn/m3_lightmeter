import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/constants.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class WriteEmailListTile extends StatefulWidget {
  const WriteEmailListTile({super.key});

  @override
  State<WriteEmailListTile> createState() => _WriteEmailListTileState();
}

class _WriteEmailListTileState extends State<WriteEmailListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.email_outlined),
      title: Text(S.of(context).writeEmail),
      onTap: () {
        final mailToUrl = Uri.parse('mailto:$contactEmail?subject=M3 Lightmeter');
        canLaunchUrl(mailToUrl).then((canLaunch) {
          if (canLaunch) {
            launchUrl(
              mailToUrl,
              mode: LaunchMode.externalApplication,
            );
          } else if (mounted) {
            _showSnackBar();
          }
        });
      },
    );
  }

  Future<void> _showSnackBar() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).youDontHaveMailApp),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: S.of(context).copyEmail,
          onPressed: () {
            FlutterClipboard.copy(contactEmail).then((_) {
              if (mounted) {
                ScaffoldMessenger.of(context).clearSnackBars();
              }
            });
          },
        ),
      ),
    );
  }
}
