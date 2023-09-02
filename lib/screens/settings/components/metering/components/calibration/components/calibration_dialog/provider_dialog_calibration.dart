import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lightmeter/screens/settings/components/metering/components/calibration/components/calibration_dialog/bloc_dialog_calibration.dart';
import 'package:lightmeter/screens/settings/components/metering/components/calibration/components/calibration_dialog/widget_dialog_calibration.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';

class CalibrationDialogProvider extends StatelessWidget {
  const CalibrationDialogProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalibrationDialogBloc(SettingsInteractorProvider.of(context)),
      child: const CalibrationDialog(),
    );
  }
}
