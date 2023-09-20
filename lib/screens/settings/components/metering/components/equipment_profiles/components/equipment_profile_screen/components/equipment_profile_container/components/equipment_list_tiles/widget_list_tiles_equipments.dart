import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_filter/widget_dialog_filter.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_range_picker/widget_dialog_picker_range.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentListTiles extends StatelessWidget {
  final List<ApertureValue> selectedApertureValues;
  final List<IsoValue> selectedIsoValues;
  final List<NdValue> selectedNdValues;
  final List<ShutterSpeedValue> selectedShutterSpeedValues;
  final ValueChanged<List<ApertureValue>> onApertureValuesSelected;
  final ValueChanged<List<IsoValue>> onIsoValuesSelecred;
  final ValueChanged<List<NdValue>> onNdValuesSelected;
  final ValueChanged<List<ShutterSpeedValue>> onShutterSpeedValuesSelected;

  const EquipmentListTiles({
    required this.selectedApertureValues,
    required this.selectedIsoValues,
    required this.selectedNdValues,
    required this.selectedShutterSpeedValues,
    required this.onApertureValuesSelected,
    required this.onIsoValuesSelecred,
    required this.onNdValuesSelected,
    required this.onShutterSpeedValuesSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _EquipmentListTile<IsoValue>(
          icon: Icons.iso,
          title: S.of(context).isoValues,
          description: S.of(context).isoValuesFilterDescription,
          values: IsoValue.values,
          selectedValues: selectedIsoValues,
          rangeSelect: false,
          onChanged: onIsoValuesSelecred,
        ),
        _EquipmentListTile<NdValue>(
          icon: Icons.filter_b_and_w,
          title: S.of(context).ndFilters,
          description: S.of(context).ndFiltersFilterDescription,
          values: NdValue.values,
          selectedValues: selectedNdValues,
          rangeSelect: false,
          onChanged: onNdValuesSelected,
        ),
        _EquipmentListTile<ApertureValue>(
          icon: Icons.camera,
          title: S.of(context).apertureValues,
          description: S.of(context).apertureValuesFilterDescription,
          values: ApertureValue.values,
          selectedValues: selectedApertureValues,
          rangeSelect: true,
          onChanged: onApertureValuesSelected,
        ),
        _EquipmentListTile<ShutterSpeedValue>(
          icon: Icons.shutter_speed,
          title: S.of(context).shutterSpeedValues,
          description: S.of(context).shutterSpeedValuesFilterDescription,
          values: ShutterSpeedValue.values,
          selectedValues: selectedShutterSpeedValues,
          rangeSelect: true,
          onChanged: onShutterSpeedValuesSelected,
        ),
      ],
    );
  }
}

class _EquipmentListTile<T extends PhotographyValue> extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<T> selectedValues;
  final List<T> values;
  final ValueChanged<List<T>> onChanged;
  final bool rangeSelect;

  const _EquipmentListTile({
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
      trailing: rangeSelect
          ? Text("${selectedValues.first} - ${selectedValues.last}")
          : Text(
              values.length == selectedValues.length
                  ? S.of(context).equipmentProfileAllValues
                  : selectedValues.length.toString(),
            ),
      onTap: () {
        showDialog<List<T>>(
          context: context,
          builder: (_) => rangeSelect
              ? DialogRangePicker<T>(
                  icon: Icon(icon),
                  title: title,
                  description: description,
                  values: values,
                  selectedValues: selectedValues,
                  titleAdapter: (_, value) => value.toString(),
                )
              : DialogFilter<T>(
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
