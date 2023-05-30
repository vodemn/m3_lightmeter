import 'package:flutter/material.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/utils/inherited_generics.dart';
import 'package:url_launcher/url_launcher.dart';

class SourceCodeListTile extends StatelessWidget {
  const SourceCodeListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.code),
      title: Text(S.of(context).sourceCode),
      onTap: () {
        launchUrl(
          Uri.parse(context.get<Environment>().sourceCodeUrl),
          mode: LaunchMode.externalApplication,
        );
      },
    );
  }
}
