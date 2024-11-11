import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmEditIsoPicker extends StatelessWidget {
  final IsoValue selected;
  final ValueChanged<IsoValue> onChanged;

  const FilmEditIsoPicker({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.iso),
      title: Text(S.of(context).iso),
      trailing: Text(selected.value.toString()),
      onTap: () {
        showDialog<IsoValue>(
          context: context,
          builder: (_) => Dialog(
            child: DialogPicker<IsoValue>(
              icon: Icons.iso,
              title: S.of(context).iso,
              subtitle: S.of(context).filmSpeed,
              values: IsoValue.values,
              initialValue: selected,
              itemTitleBuilder: (_, value) => Text(value.value.toString()),
              onSelect: (value) {
                onChanged(value);
                Navigator.of(context).pop();
              },
              onCancel: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }
}
