import 'package:flutter/material.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import '../dialog_filter/widget_dialog_filter.dart';

class EquipmentListTile<T extends PhotographyValue> extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<T> selectedValues;
  final List<T> values;
  final ValueChanged<List<T>> onChanged;
  final bool rangeSelect;

  const EquipmentListTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.selectedValues,
    required this.values,
    required this.onChanged,
    required this.rangeSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => DialogFilter<T>(
            icon: Icon(icon),
            title: title,
            description: description,
            values: values,
            titleAdapter: (_, value) => value.toString(),
            rangeSelect: rangeSelect,
          ),
        );
      },
    );
  }
}
