import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/shared/text_field/widget_text_field.dart';

class FilmEditExponentialFormulaInput extends StatefulWidget {
  final double? value;
  final ValueChanged<double?> onChanged;

  const FilmEditExponentialFormulaInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<FilmEditExponentialFormulaInput> createState() => _FilmEditExponentialFormulaInputState();
}

class _FilmEditExponentialFormulaInputState extends State<FilmEditExponentialFormulaInput> {
  TextStyle get style =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).listTileTheme.textColor);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.show_chart),
          title: Text(S.of(context).filmFormula),
          trailing: Text(S.of(context).filmFormulaExponential),
        ),
        ListTile(
          leading: const SizedBox(),
          title: Text(
            S.of(context).filmFormulaExponentialRf,
            style: Theme.of(context).listTileTheme.titleTextStyle,
          ),
          trailing: SizedBox(
            width: _textInputWidth(context),
            child: LightmeterTextField(
              initialValue: widget.value?.toString() ?? '',
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
              onChanged: (value) {
                widget.onChanged(double.tryParse(value));
              },
              textAlign: TextAlign.end,
              style: style,
            ),
          ),
        ),
      ],
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
