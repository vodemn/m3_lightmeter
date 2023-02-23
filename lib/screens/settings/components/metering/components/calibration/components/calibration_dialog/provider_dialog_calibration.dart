import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';

import 'bloc_dialog_calibration.dart';
import 'widget_dialog_calibration.dart';

class CalibrationDialogProvider extends StatelessWidget {
  const CalibrationDialogProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalibrationDialogBloc(context.read<SettingsInteractor>()),
      child: const CalibrationDialog(),
    );
  }
}
