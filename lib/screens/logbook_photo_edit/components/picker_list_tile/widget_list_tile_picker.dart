import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_picker/widget_dialog_picker.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class PickerListTile<T> extends StatelessWidget {
  final IconData icon;
  final String title;
  final T? selectedValue;
  final List<T> values;
  final String Function(T) titleAdapter;
  final ValueChanged<Optional<T>> onChanged;

  const PickerListTile({
    required this.icon,
    required this.title,
    required this.selectedValue,
    required this.values,
    required this.titleAdapter,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(_titleAdapter(context, selectedValue)),
      onTap: () {
        showDialog<Optional<T>>(
          context: context,
          builder: (_) => DialogPicker<Optional<T>>(
            icon: icon,
            title: title,
            selectedValue: Optional(selectedValue),
            values: [
              const Optional(null),
              ...values.toSet().map((e) => Optional(e)),
            ],
            titleAdapter: (context, value) => _titleAdapter(context, value.value),
          ),
        ).then((value) {
          if (value != null) {
            onChanged(value);
          }
        });
      },
    );
  }

  String _titleAdapter(BuildContext context, T? value) {
    return value != null ? titleAdapter(value) : S.of(context).notSet;
  }
}
