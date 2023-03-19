import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import 'components/equipment_list_tile/widget_list_tile_equipment.dart';

class EquipmentListTilesSection extends StatefulWidget {
  final EquipmentProfileData data;

  const EquipmentListTilesSection({required this.data, super.key});

  @override
  State<EquipmentListTilesSection> createState() => _EquipmentListTilesSectionState();
}

class _EquipmentListTilesSectionState extends State<EquipmentListTilesSection> {
  final TextEditingController _nameController = TextEditingController(text: 'Default');
  final FocusNode _fieldFocusNode = FocusNode();
  bool _expanded = false;

  @override
  void dispose() {
    _nameController.dispose();
    _fieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimens.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Dimens.paddingM,
                      0,
                      Dimens.paddingM,
                      0,
                    ),
                    child: IgnorePointer(
                      ignoring: !_expanded,
                      child: TextFormField(
                        focusNode: _fieldFocusNode,
                        controller: _nameController,
                        onChanged: (value) {},
                        decoration: const InputDecoration(
                          hintText: 'Profile name',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    _collapseButton(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
            if (_expanded) const _DialogsListTiles()
          ],
        ),
      ),
    );
  }

  Widget _collapseButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          _expanded = !_expanded;
        });
        if (!_expanded) {
          _fieldFocusNode.unfocus();
        }
      },
      icon: Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
    );
  }
}

class _DialogsListTiles extends StatelessWidget {
  const _DialogsListTiles();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        EquipmentListTile<IsoValue>(
          icon: Icons.iso,
          title: S.of(context).isoValues,
          description: S.of(context).isoValuesFilterDescription,
          values: isoValues,
          selectedValues: const [],
          rangeSelect: false,
          onChanged: (value) {},
        ),
        EquipmentListTile<NdValue>(
          icon: Icons.filter_b_and_w,
          title: S.of(context).ndFilters,
          description: S.of(context).ndFiltersFilterDescription,
          values: ndValues,
          selectedValues: const [],
          rangeSelect: false,
          onChanged: (value) {},
        ),
        EquipmentListTile<ApertureValue>(
          icon: Icons.camera,
          title: S.of(context).apertureValues,
          description: S.of(context).apertureValuesFilterDescription,
          values: apertureValues,
          selectedValues: const [],
          rangeSelect: true,
          onChanged: (value) {},
        ),
        EquipmentListTile<ShutterSpeedValue>(
          icon: Icons.shutter_speed,
          title: S.of(context).shutterSpeedValues,
          description: S.of(context).shutterSpeedValuesFilterDescription,
          values: shutterSpeedValues,
          selectedValues: const [],
          rangeSelect: true,
          onChanged: (value) {},
        ),
      ],
    );
  }
}
