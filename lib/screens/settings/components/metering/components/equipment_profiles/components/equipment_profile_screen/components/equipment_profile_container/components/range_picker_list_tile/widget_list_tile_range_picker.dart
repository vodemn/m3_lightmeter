import 'package:flutter/material.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_range_picker/widget_dialog_picker_range.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class RangePickerListTile<T extends PhotographyValue> extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<T> selectedValues;
  final List<T> values;
  final String Function(BuildContext context, T value)? trailingAdapter;
  final String Function(BuildContext context, T value)? dialogValueAdapter;
  final ValueChanged<List<T>> onChanged;

  const RangePickerListTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.selectedValues,
    required this.values,
    this.trailingAdapter,
    this.dialogValueAdapter,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(_trailing(context)),
      onTap: () {
        showDialog<List<T>>(
          context: context,
          builder: (_) => DialogRangePicker<T>(
            icon: Icon(icon),
            title: title,
            description: description,
            values: values,
            selectedValues: selectedValues,
            valueAdapter: (context, value) => dialogValueAdapter?.call(context, value) ?? value.toString(),
          ),
        ).then((values) {
          if (values != null) {
            onChanged(values);
          }
        });
      },
    );
  }

  String _trailing(BuildContext context) {
    final buffer = StringBuffer();
    buffer.write(trailingAdapter?.call(context, selectedValues.first) ?? selectedValues.first);
    if (selectedValues.first != selectedValues.last) {
      buffer.writeAll([
        ' - ',
        trailingAdapter?.call(context, selectedValues.last) ?? selectedValues.last,
      ]);
    }
    return buffer.toString();
  }
}
