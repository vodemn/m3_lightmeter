import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import 'components/equipment_list_tiles/widget_list_tiles_equipments.dart';

class EquipmentProfileContainer extends StatefulWidget {
  final EquipmentProfileData data;
  final ValueChanged<EquipmentProfileData> onUpdate;
  final VoidCallback onDelete;
  final VoidCallback onExpand;

  const EquipmentProfileContainer({
    required this.data,
    required this.onUpdate,
    required this.onDelete,
    required this.onExpand,
    super.key,
  });

  @override
  State<EquipmentProfileContainer> createState() => EquipmentProfileContainerState();
}

class EquipmentProfileContainerState extends State<EquipmentProfileContainer> {
  late EquipmentProfileData _equipmentProfileData = EquipmentProfileData(
    id: widget.data.id,
    name: widget.data.name,
    apertureValues: widget.data.apertureValues,
    ndValues: widget.data.ndValues,
    shutterSpeedValues: widget.data.shutterSpeedValues,
    isoValues: widget.data.isoValues,
  );
  late final _nameController = TextEditingController(text: _equipmentProfileData.name);
  final _fieldFocusNode = FocusNode();
  bool _expanded = false;

  @override
  void didUpdateWidget(EquipmentProfileContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _equipmentProfileData = EquipmentProfileData(
      id: widget.data.id,
      name: widget.data.name,
      apertureValues: widget.data.apertureValues,
      ndValues: widget.data.ndValues,
      shutterSpeedValues: widget.data.shutterSpeedValues,
      isoValues: widget.data.isoValues,
    );
  }

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
                        onFieldSubmitted: (value) {
                          _equipmentProfileData = _equipmentProfileData.copyWith(name: value);
                          widget.onUpdate(_equipmentProfileData);
                        },
                        decoration: InputDecoration(
                          hintText: S.of(context).equipmentProfileNameHint,
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
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
            if (_expanded)
              EquipmentListTiles(
                selectedApertureValues: _equipmentProfileData.apertureValues,
                selectedIsoValues: _equipmentProfileData.isoValues,
                selectedNdValues: _equipmentProfileData.ndValues,
                selectedShutterSpeedValues: _equipmentProfileData.shutterSpeedValues,
                onApertureValuesSelected: (value) {
                  _equipmentProfileData = _equipmentProfileData.copyWith(apertureValues: value);
                  widget.onUpdate(_equipmentProfileData);
                },
                onIsoValuesSelecred: (value) {
                  _equipmentProfileData = _equipmentProfileData.copyWith(isoValues: value);
                  widget.onUpdate(_equipmentProfileData);
                },
                onNdValuesSelected: (value) {
                  _equipmentProfileData = _equipmentProfileData.copyWith(ndValues: value);
                  widget.onUpdate(_equipmentProfileData);
                },
                onShutterSpeedValuesSelected: (value) {
                  _equipmentProfileData = _equipmentProfileData.copyWith(shutterSpeedValues: value);
                  widget.onUpdate(_equipmentProfileData);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _collapseButton() {
    return IconButton(
      onPressed: _expanded ? collapse : expand,
      icon: Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
    );
  }

  void expand() {
    widget.onExpand();
    setState(() {
      _expanded = true;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Scrollable.ensureVisible(
        context,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      );
    });
  }

  void collapse() {
    setState(() {
      _expanded = false;
    });
    _fieldFocusNode.unfocus();
  }
}
