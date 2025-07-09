import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_picker/widget_dialog_picker.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class PickerListTile<T extends PhotographyValue> extends StatelessWidget {
  final IconData icon;
  final String title;
  final T? selectedValue;
  final List<T> values;
  final ValueChanged<T?> onChanged;

  const PickerListTile({
    required this.icon,
    required this.title,
    required this.selectedValue,
    required this.values,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(selectedValue?.toString() ?? S.of(context).notSet),
      onTap: () {
        showDialog<T?>(
          context: context,
          builder: (_) => DialogPicker<T?>(
            icon: icon,
            title: title,
            selectedValue: selectedValue,
            values: [null, ...values],
            titleAdapter: (context, value) => value?.toString() ?? S.of(context).notSet,
          ),
        ).then((value) {
          if (value != null) {
            onChanged(value);
          }
        });
      },
    );
  }
}
