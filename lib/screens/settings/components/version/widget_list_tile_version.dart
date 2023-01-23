import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';


class VersionListTile extends StatelessWidget {
  const VersionListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: Text(S.of(context).version('', '')),
    );
  }
}