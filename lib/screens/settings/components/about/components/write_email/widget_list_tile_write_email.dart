import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WriteEmailListTile extends StatelessWidget {
  const WriteEmailListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.email),
      title: Text(S.of(context).writeEmail),
      onTap: () {
        final email = context.read<Environment>().contactEmail;
        final mailToUrl = Uri.parse('mailto:$email?subject=M3 Lightmeter');
        canLaunchUrl(mailToUrl).then((canLaunch) {
          if (canLaunch) {
            launchUrl(
              mailToUrl,
              mode: LaunchMode.externalApplication,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).youDontHaveMailApp),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: S.of(context).copyEmail,
                  onPressed: () {
                    FlutterClipboard.copy(email).then((_) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                    });
                  },
                ),
              ),
            );
          }
        });
      },
    );
  }

  void _copyEmail(BuildContext context) {
    FlutterClipboard.copy(context.read<Environment>().contactEmail).then((_) {
      ScaffoldMessenger.of(context).clearSnackBars();
    });
  }
}
