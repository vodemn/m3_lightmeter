import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';

class NdFiltersListTile extends StatelessWidget {
  const NdFiltersListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.filter_b_and_w),
      title: Text(S.of(context).ndFilters),
    );
  }
}
