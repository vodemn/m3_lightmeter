import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import 'components/equipment_list_tiles/widget_list_tiles_equipments.dart';

class EquipmentProfileContainer extends StatefulWidget {
  final EquipmentProfileData data;
  final VoidCallback onExpand;
  final VoidCallback onDelete;

  const EquipmentProfileContainer({
    required this.data,
    required this.onExpand,
    required this.onDelete,
    super.key,
  });

  @override
  State<EquipmentProfileContainer> createState() => EquipmentProfileContainerState();
}

class EquipmentProfileContainerState extends State<EquipmentProfileContainer> {
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
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
            if (_expanded)
              EquipmentListTiles(
                selectedApertureValues: widget.data.apertureValues,
                selectedIsoValues: widget.data.isoValues,
                selectedNdValues: widget.data.ndValues,
                selectedShutterSpeedValues: widget.data.shutterSpeedValues,
                onApertureValuesSelected: (value) {},
                onIsoValuesSelecred: (value) {},
                onNdValuesSelected: (value) {},
                onShutterSpeedValuesSelected: (value) {},
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
