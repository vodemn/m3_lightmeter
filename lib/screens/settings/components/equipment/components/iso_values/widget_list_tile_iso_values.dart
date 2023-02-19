import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';

class IsoValuesListTile extends StatelessWidget {
  const IsoValuesListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.iso),
      title: Text(S.of(context).isoValues),
    );
  }
}
