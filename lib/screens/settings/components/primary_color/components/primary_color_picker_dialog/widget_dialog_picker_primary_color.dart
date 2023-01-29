import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/theme_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/shared/filled_circle/widget_circle_filled.dart';

class PrimaryColorDialogPicker extends StatefulWidget {
  const PrimaryColorDialogPicker({super.key});

  @override
  State<PrimaryColorDialogPicker> createState() => _PrimaryColorDialogPickerState();
}

class _PrimaryColorDialogPickerState extends State<PrimaryColorDialogPicker> {
  late Color _selected = Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(
        Dimens.paddingL,
        Dimens.paddingL,
        Dimens.paddingL,
        Dimens.paddingM,
      ),
      title: Text(S.of(context).choosePrimaryColor),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        height: Dimens.grid48,
        width: double.maxFinite,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingL),
          separatorBuilder: (_, __) => const SizedBox(width: Dimens.grid8),
          itemCount: ThemeProvider.primaryColorsList.length,
          itemBuilder: (_, index) {
            final color = ThemeProvider.primaryColorsList[index];
            return _SelectableColorItem(
              color: color,
              selected: color.value == _selected.value,
              onTap: () {
                setState(() {
                  _selected = color;
                });
              },
            );
          },
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
            Navigator.of(context).pop(_selected);
          },
          child: Text(S.of(context).save),
        ),
      ],
    );
  }
}

class _SelectableColorItem extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  _SelectableColorItem({
    required this.color,
    required this.selected,
    required this.onTap,
  }) : super(key: ValueKey(color));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FilledCircle(
        size: Dimens.grid48,
        color: color,
        child: AnimatedSwitcher(
          duration: Dimens.durationS,
          child: selected
              ? Icon(
                  Icons.check,
                  color: ThemeData.estimateBrightnessForColor(color) == Brightness.light
                      ? Colors.black
                      : Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}
