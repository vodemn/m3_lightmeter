import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/components/metering/components/equipment_profiles/components/equipment_profile_screen/components/equipment_profile_name_dialog/widget_dialog_equipment_profile_name.dart';
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
  late EquipmentProfileData _equipmentData = EquipmentProfileData(
    id: widget.data.id,
    name: widget.data.name,
    apertureValues: widget.data.apertureValues,
    ndValues: widget.data.ndValues,
    shutterSpeedValues: widget.data.shutterSpeedValues,
    isoValues: widget.data.isoValues,
  );
  bool _expanded = false;

  @override
  void didUpdateWidget(EquipmentProfileContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _equipmentData = EquipmentProfileData(
      id: widget.data.id,
      name: widget.data.name,
      apertureValues: widget.data.apertureValues,
      ndValues: widget.data.ndValues,
      shutterSpeedValues: widget.data.shutterSpeedValues,
      isoValues: widget.data.isoValues,
    );
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
            ListTile(
              title: Text(
                _equipmentData.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _collapseButton(),
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (_) => EquipmentProfileNameDialog(initialValue: _equipmentData.name),
                ).then((value) {
                  if (value != null) {
                    _equipmentData = _equipmentData.copyWith(name: value);
                    widget.onUpdate(_equipmentData);
                  }
                });
              },
            ),
            AnimatedSize(
              alignment: Alignment.topCenter,
              duration: Dimens.durationM,
              child: _expanded
                  ? EquipmentListTiles(
                      selectedApertureValues: _equipmentData.apertureValues,
                      selectedIsoValues: _equipmentData.isoValues,
                      selectedNdValues: _equipmentData.ndValues,
                      selectedShutterSpeedValues: _equipmentData.shutterSpeedValues,
                      onApertureValuesSelected: (value) {
                        _equipmentData = _equipmentData.copyWith(apertureValues: value);
                        widget.onUpdate(_equipmentData);
                      },
                      onIsoValuesSelecred: (value) {
                        _equipmentData = _equipmentData.copyWith(isoValues: value);
                        widget.onUpdate(_equipmentData);
                      },
                      onNdValuesSelected: (value) {
                        _equipmentData = _equipmentData.copyWith(ndValues: value);
                        widget.onUpdate(_equipmentData);
                      },
                      onShutterSpeedValuesSelected: (value) {
                        _equipmentData = _equipmentData.copyWith(shutterSpeedValues: value);
                        widget.onUpdate(_equipmentData);
                      },
                    )
                  : Row(mainAxisSize: MainAxisSize.max),
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
  }
}
