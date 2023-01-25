import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';

import 'components/calibration_dialog/widget_dialog_calibration.dart';

class CalibrationListTile extends StatelessWidget {
  const CalibrationListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.settings_brightness),
      title: Text(S.of(context).calibration),
      onTap: () {
        showDialog<double>(
          context: context,
          builder: (_) => CalibrationDialog(
            cameraEvCalibration: 0.0,
          ),
        ).then((value) {
          if (value != null) {}
        });
      },
    );
  }
}
