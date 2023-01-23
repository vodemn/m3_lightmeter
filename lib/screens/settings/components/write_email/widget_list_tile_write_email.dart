import 'package:flutter/material.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/generated/l10n.dart';
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
        launchUrl(Uri.parse('mailto:${context.read<Environment>().issuesReportUrl}?subject=M3 Lightmeter'));
      },
    );
  }
}
