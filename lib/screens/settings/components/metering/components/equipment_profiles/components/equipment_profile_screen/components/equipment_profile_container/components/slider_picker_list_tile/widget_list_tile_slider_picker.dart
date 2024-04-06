import 'package:flutter/material.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_slider_picker/widget_dialog_slider_picker.dart';

class SliderPickerListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final double value;
  final RangeValues range;
  final ValueChanged<double> onChanged;
  final String Function(BuildContext, double) valueAdapter;

  const SliderPickerListTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.range,
    required this.onChanged,
    required this.valueAdapter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(valueAdapter(context, value)),
      onTap: () {
        showDialog<double>(
          context: context,
          builder: (_) => DialogSliderPicker(
            icon: Icon(icon),
            title: title,
            description: description,
            value: value,
            range: range,
            valueAdapter: valueAdapter,
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
