import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/shared/text_field/widget_text_field.dart';

class EquipmentProfileApertureInput extends StatefulWidget {
  final double? value;
  final ValueChanged<double?> onChanged;

  const EquipmentProfileApertureInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<EquipmentProfileApertureInput> createState() => _EquipmentProfileApertureInputState();
}

class _EquipmentProfileApertureInputState extends State<EquipmentProfileApertureInput> {
  TextStyle get style =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).listTileTheme.textColor);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.camera),
      title: Text(
        S.of(context).apertureValue,
        style: Theme.of(context).listTileTheme.titleTextStyle,
      ),
      trailing: SizedBox(
        width: _textInputWidth(context),
        child: LightmeterTextField(
          initialValue: widget.value?.toString() ?? '',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
            LengthLimitingTextInputFormatter(6),
          ],
          onChanged: (value) {
            final parsed = double.tryParse(value);
            widget.onChanged(parsed != null && parsed > 0 ? parsed : null);
          },
          validator: (value) {
            final parsed = double.tryParse(value);
            if (parsed != null && parsed > 0) {
              return null;
            } else {
              return '';
            }
          },
          textAlign: TextAlign.end,
          style: style,
        ),
      ),
    );
  }

  double _textInputWidth(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.value.toString(), style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.maxIntrinsicWidth + Dimens.grid4;
  }
}
