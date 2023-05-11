import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';

import 'package:lightmeter/screens/settings/components/metering/components/metering_screen_layout/components/meterins_screen_layout_features_dialog/widget_dialog_metering_screen_layout_features.dart';

class MeteringScreenLayoutListTile extends StatelessWidget {
  const MeteringScreenLayoutListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.layers_outlined),
      title: Text(S.of(context).meteringScreenLayout),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => const MeteringScreenLayoutFeaturesDialog(),
        );
      },
    );
  }
}
