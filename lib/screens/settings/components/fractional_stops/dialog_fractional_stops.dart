import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/models/photography_value.dart';

class FractionalStopsDialog extends StatefulWidget {
  final StopType selectedType;

  const FractionalStopsDialog({required this.selectedType, super.key});

  @override
  State<FractionalStopsDialog> createState() => _FractionalStopsDialogState();
}

class _FractionalStopsDialogState extends State<FractionalStopsDialog> {
  late StopType _selected = widget.selectedType;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(S.of(context).showFractionalStops),
      children: [
        RadioListTile<StopType>(
          value: StopType.full,
          groupValue: _selected,
          title: Text(S.of(context).none),
          onChanged: _onChanged,
        ),
        RadioListTile<StopType>(
          value: StopType.half,
          groupValue: _selected,
          title: Text(S.of(context).halfStops),
          onChanged: _onChanged,
        ),
        RadioListTile<StopType>(
          value: StopType.third,
          groupValue: _selected,
          title: Text(S.of(context).thirdStops),
          onChanged: _onChanged,
        ),
      ],
    );
  }

  void _onChanged(StopType? value) {
    setState(() {
      _selected = value!;
    });
    Navigator.of(context).pop(_selected);
  }
}
