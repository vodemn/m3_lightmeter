import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class SourceCodeListTile extends StatelessWidget {
  const SourceCodeListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.code),
      title: Text(S.of(context).sourceCode),
      onTap: () {
        launchUrl(Uri.parse("https://github.com/vodemn/m3_lightmeter"));
      },
    );
  }
}
