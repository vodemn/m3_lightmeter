import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';
import 'package:lightmeter/screens/settings/components/metering/components/calibration/components/calibration_dialog/provider_dialog_calibration.dart';
import 'package:provider/provider.dart';

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
          builder: (_) => Provider.value(
            value: context.read<SettingsInteractor>(),
            child: const CalibrationDialogProvider(),
          ),
        );
      },
    );
  }
}
