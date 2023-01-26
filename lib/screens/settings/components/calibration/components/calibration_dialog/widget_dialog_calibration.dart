import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/components/calibration/components/calibration_dialog/event_dialog_calibration.dart';
import 'package:lightmeter/screens/shared/centered_slider/widget_slider_centered.dart';
import 'package:lightmeter/utils/to_string_signed.dart';

import 'bloc_dialog_calibration.dart';
import 'state_dialog_calibration.dart';

class CalibrationDialog extends StatefulWidget {
  const CalibrationDialog({super.key});

  @override
  State<CalibrationDialog> createState() => _CalibrationDialogState();
}

class _CalibrationDialogState extends State<CalibrationDialog> {
  CalibrationDialogBloc get bloc => context.read<CalibrationDialogBloc>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(
        Dimens.paddingL,
        Dimens.paddingL,
        Dimens.paddingL,
        Dimens.paddingM,
      ),
      title: Text(S.of(context).calibration),
      contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingL),
      content: BlocBuilder<CalibrationDialogBloc, CalibrationDialogState>(
        builder: (context, state) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.of(context).calibrationMessage),
            const SizedBox(height: Dimens.grid16),
            _CalibrationUnit(
              title: S.of(context).camera,
              value: state.cameraEvCalibration,
              onChanged: (value) => bloc.add(CameraEvCalibrationChangedEvent(value)),
              onReset: () => bloc.add(const CameraEvCalibrationResetEvent()),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        Dimens.paddingL,
        Dimens.paddingM,
        Dimens.paddingL,
        Dimens.paddingL,
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(S.of(context).cancel),
        ),
        TextButton(
          onPressed: () {
            bloc.add(const SaveCalibrationDialogEvent());
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).save),
        ),
      ],
    );
  }
}

class _CalibrationUnit extends StatelessWidget {
  final String title;
  final double value;
  final ValueChanged<double> onChanged;
  final VoidCallback onReset;

  const _CalibrationUnit({
    required this.title,
    required this.value,
    required this.onChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title),
          trailing: Text(S.of(context).ev(value.toStringSignedAsFixed(1))),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: CenteredSlider(
                value: value,
                min: -4,
                max: 4,
                onChanged: onChanged,
              ),
            ),
            IconButton(
              onPressed: onReset,
              icon: const Icon(Icons.sync),
            ),
          ],
        )
      ],
    );
  }
}
