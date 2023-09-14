import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/components/equipment/components/equipment_profiles/components/equipment_profile_screen/components/equipment_profile_container/components/equipment_list_tiles/widget_list_tiles_equipments.dart';
import 'package:lightmeter/screens/settings/components/equipment/components/equipment_profiles/components/equipment_profile_screen/components/equipment_profile_name_dialog/widget_dialog_equipment_profile_name.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfileContainer extends StatefulWidget {
  final EquipmentProfile data;
  final ValueChanged<EquipmentProfile> onUpdate;
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

class EquipmentProfileContainerState extends State<EquipmentProfileContainer>
    with TickerProviderStateMixin {
  late EquipmentProfile _equipmentData = EquipmentProfile(
    id: widget.data.id,
    name: widget.data.name,
    apertureValues: widget.data.apertureValues,
    ndValues: widget.data.ndValues,
    shutterSpeedValues: widget.data.shutterSpeedValues,
    isoValues: widget.data.isoValues,
  );

  late final AnimationController _controller = AnimationController(
    duration: Dimens.durationM,
    vsync: this,
  );
  bool get _expanded => _controller.isCompleted;

  @override
  void didUpdateWidget(EquipmentProfileContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _equipmentData = EquipmentProfile(
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
    _controller.dispose();
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
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
              title: Row(
                children: [
                  _AnimatedNameLeading(controller: _controller),
                  const SizedBox(width: Dimens.grid8),
                  Flexible(
                    child: Text(
                      _equipmentData.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _AnimatedArrowButton(
                    controller: _controller,
                    onPressed: () => _expanded ? collapse() : expand(),
                  ),
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              onTap: () => _expanded ? _showNameDialog() : expand(),
            ),
            _AnimatedEquipmentListTiles(
              controller: _controller,
              equipmentData: _equipmentData,
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
            ),
          ],
        ),
      ),
    );
  }

  void _showNameDialog() {
    showDialog<String>(
      context: context,
      builder: (_) => EquipmentProfileNameDialog(initialValue: _equipmentData.name),
    ).then((value) {
      if (value != null) {
        _equipmentData = _equipmentData.copyWith(name: value);
        widget.onUpdate(_equipmentData);
      }
    });
  }

  void expand() {
    widget.onExpand();
    _controller.forward();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(_controller.duration!).then((_) {
        Scrollable.ensureVisible(
          context,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          duration: _controller.duration!,
        );
      });
    });
  }

  void collapse() {
    _controller.reverse();
  }
}

class _AnimatedNameLeading extends AnimatedWidget {
  const _AnimatedNameLeading({required AnimationController controller})
      : super(listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: _progress.value * Dimens.grid8),
      child: Icon(
        Icons.edit,
        size: _progress.value * Dimens.grid24,
      ),
    );
  }
}

class _AnimatedArrowButton extends AnimatedWidget {
  final VoidCallback onPressed;

  const _AnimatedArrowButton({
    required AnimationController controller,
    required this.onPressed,
  }) : super(listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Transform.rotate(
        angle: _progress.value * pi,
        child: const Icon(Icons.keyboard_arrow_down),
      ),
    );
  }
}

class _AnimatedEquipmentListTiles extends AnimatedWidget {
  final EquipmentProfile equipmentData;
  final ValueChanged<List<ApertureValue>> onApertureValuesSelected;
  final ValueChanged<List<IsoValue>> onIsoValuesSelecred;
  final ValueChanged<List<NdValue>> onNdValuesSelected;
  final ValueChanged<List<ShutterSpeedValue>> onShutterSpeedValuesSelected;

  const _AnimatedEquipmentListTiles({
    required AnimationController controller,
    required this.equipmentData,
    required this.onApertureValuesSelected,
    required this.onIsoValuesSelecred,
    required this.onNdValuesSelected,
    required this.onShutterSpeedValuesSelected,
  }) : super(listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return SizedOverflowBox(
      alignment: Alignment.topCenter,
      size: Size(
        double.maxFinite,
        _progress.value * Dimens.grid56 * 4,
      ),
      child: Opacity(
        opacity: _progress.value,
        child: EquipmentListTiles(
          selectedApertureValues: equipmentData.apertureValues,
          selectedIsoValues: equipmentData.isoValues,
          selectedNdValues: equipmentData.ndValues,
          selectedShutterSpeedValues: equipmentData.shutterSpeedValues,
          onApertureValuesSelected: onApertureValuesSelected,
          onIsoValuesSelecred: onIsoValuesSelecred,
          onNdValuesSelected: onNdValuesSelected,
          onShutterSpeedValuesSelected: onShutterSpeedValuesSelected,
        ),
      ),
    );
  }
}
