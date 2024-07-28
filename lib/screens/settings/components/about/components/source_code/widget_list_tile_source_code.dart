import 'package:flutter/material.dart';
import 'package:lightmeter/constants.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class SourceCodeListTile extends StatelessWidget {
  const SourceCodeListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.code_outlined),
      title: Text(S.of(context).sourceCode),
      onTap: () {
        launchUrl(
          Uri.parse(sourceCodeUrl),
          mode: LaunchMode.externalApplication,
        );
      },
    );
  }
}
