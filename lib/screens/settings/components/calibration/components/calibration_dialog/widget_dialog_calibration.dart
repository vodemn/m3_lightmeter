import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/shared/centered_slider/widget_slider_centered.dart';
import 'package:lightmeter/utils/to_string_signed.dart';

class CalibrationDialog extends StatefulWidget {
  final double cameraEvCalibration;

  const CalibrationDialog({
    required this.cameraEvCalibration,
    super.key,
  });

  @override
  State<CalibrationDialog> createState() => _CalibrationDialogState();
}

class _CalibrationDialogState extends State<CalibrationDialog> {
  late double _cameraEvCalibration = widget.cameraEvCalibration;

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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(S.of(context).calibrationMessage),
          const SizedBox(height: Dimens.grid16),
          _CalibrationUnit(
            title: S.of(context).camera,
            value: _cameraEvCalibration,
            onChanged: (value) {
              setState(() {
                _cameraEvCalibration = value;
              });
            },
          ),
        ],
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
          onPressed: () => Navigator.of(context).pop(_cameraEvCalibration),
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

  const _CalibrationUnit({
    required this.title,
    required this.value,
    required this.onChanged,
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
              onPressed: () {
                onChanged(0.0);
              },
              icon: const Icon(Icons.sync),
            ),
          ],
        )
      ],
    );
  }
}
