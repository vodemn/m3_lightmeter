import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/shared/text_field/widget_text_field.dart';

class FilmEditNameField extends StatelessWidget {
  final String name;
  final ValueChanged<String> onChanged;

  const FilmEditNameField({
    required this.name,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimens.paddingM,
        top: Dimens.paddingS / 2,
        right: Dimens.paddingL,
        bottom: Dimens.paddingS / 2,
      ),
      child: LightmeterTextField(
        initialValue: name,
        maxLength: 48,
        hintText: S.of(context).name,
        onChanged: onChanged,
        style: Theme.of(context).listTileTheme.titleTextStyle,
        leading: const Icon(Icons.edit_outlined),
      ),
    );
  }
}
