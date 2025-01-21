import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_filter/widget_dialog_filter.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilterListTile<T extends PhotographyValue> extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<T> selectedValues;
  final List<T> values;
  final ValueChanged<List<T>> onChanged;

  const FilterListTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.selectedValues,
    required this.values,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(
        values.length == selectedValues.length
            ? S.of(context).equipmentProfileAllValues
            : selectedValues.length.toString(),
      ),
      onTap: () {
        showDialog<List<T>>(
          context: context,
          builder: (_) => DialogFilter<T>(
            icon: Icon(icon),
            title: title,
            description: description,
            values: values,
            selectedValues: selectedValues,
            titleAdapter: (_, value) => value.toString(),
          ),
        ).then((values) {
          if (values != null) {
            onChanged(values);
          }
        });
      },
    );
  }
}
