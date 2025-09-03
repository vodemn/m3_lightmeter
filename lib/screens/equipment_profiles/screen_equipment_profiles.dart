import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/navigation/routes.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/equipment_profile_edit/flow_equipment_profile_edit.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_picker/widget_dialog_picker.dart';
import 'package:lightmeter/screens/shared/sliver_placeholder/widget_sliver_placeholder.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:lightmeter/utils/guard_pro_tap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

enum _EquipmentProfileType { regular, pinhole }

class EquipmentProfilesScreen extends StatefulWidget {
  const EquipmentProfilesScreen({super.key});

  @override
  State<EquipmentProfilesScreen> createState() => _EquipmentProfilesScreenState();
}

class _EquipmentProfilesScreenState extends State<EquipmentProfilesScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SliverScreen(
      title: Text(S.of(context).equipmentProfiles),
      appBarActions: [
        IconButton(
          onPressed: _addProfile,
          icon: const Icon(Icons.add_outlined),
          tooltip: S.of(context).tooltipAdd,
        ),
      ],
      slivers: [
        if (EquipmentProfiles.of(context).length > 1)
          _EquipmentProfilesListBuilder(
            values: EquipmentProfiles.of(context).skip(1).toList(),
            onEdit: _editProfile,
            onCheckbox: EquipmentProfilesProvider.of(context).toggleProfile,
          )
        else
          SliverPlaceholder(onTap: _addProfile),
      ],
    );
  }

  void _addProfile() {
    guardProTap(
      context,
      () {
        showDialog<_EquipmentProfileType>(
          context: context,
          builder: (_) => DialogPicker<_EquipmentProfileType>(
            icon: Icons.camera_alt_outlined,
            title: S.of(context).equipmentProfileType,
            selectedValue: _EquipmentProfileType.regular,
            values: _EquipmentProfileType.values,
            titleAdapter: (context, value) => switch (value) {
              _EquipmentProfileType.regular => S.of(context).camera,
              _EquipmentProfileType.pinhole => S.of(context).pinholeCamera,
            },
          ),
        ).then((value) {
          if (value != null && mounted) {
            Navigator.of(context).pushNamed(
              NavigationRoutes.equipmentProfileEditScreen.name,
              arguments: switch (value) {
                _EquipmentProfileType.regular => const EquipmentProfileEditArgs(
                    editType: EquipmentProfileEditType.add,
                    profile: EquipmentProfilesProvider.defaultProfile,
                  ),
                _EquipmentProfileType.pinhole => EquipmentProfileEditArgs(
                    editType: EquipmentProfileEditType.add,
                    profile: PinholeEquipmentProfile(
                      id: EquipmentProfilesProvider.defaultProfile.id,
                      name: EquipmentProfilesProvider.defaultProfile.name,
                      aperture: 22,
                      isoValues: EquipmentProfilesProvider.defaultProfile.isoValues,
                      ndValues: EquipmentProfilesProvider.defaultProfile.ndValues,
                    ),
                  ),
              },
            );
          }
        });
      },
    );
  }

  void _editProfile(IEquipmentProfile profile) {
    Navigator.of(context).pushNamed(
      NavigationRoutes.equipmentProfileEditScreen.name,
      arguments: EquipmentProfileEditArgs(
        editType: EquipmentProfileEditType.edit,
        profile: profile,
      ),
    );
  }
}

class _EquipmentProfilesListBuilder extends StatelessWidget {
  final List<IEquipmentProfile> values;
  final void Function(IEquipmentProfile profile) onEdit;
  final void Function(String id, bool value) onCheckbox;

  const _EquipmentProfilesListBuilder({
    required this.values,
    required this.onEdit,
    required this.onCheckbox,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: values.length,
      itemBuilder: (_, index) => Padding(
        padding: EdgeInsets.fromLTRB(
          Dimens.paddingM,
          index == 0 ? Dimens.paddingM : 0,
          Dimens.paddingM,
          index == values.length - 1 ? Dimens.paddingM + MediaQuery.paddingOf(context).bottom : 0.0,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: index == 0 ? const Radius.circular(Dimens.borderRadiusL) : Radius.zero,
              bottom: index == values.length - 1 ? const Radius.circular(Dimens.borderRadiusL) : Radius.zero,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: index == 0 ? Dimens.paddingM : 0.0,
              bottom: index == values.length - 1 ? Dimens.paddingM : 0.0,
            ),
            child: CheckboxListTile(
              title: Text(values[index].name),
              controlAffinity: ListTileControlAffinity.leading,
              value: EquipmentProfiles.inUseOf(context).contains(values[index]),
              onChanged: (value) => onCheckbox(values[index].id, value ?? false),
              secondary: IconButton(
                onPressed: () => onEdit(values[index]),
                icon: const Icon(Icons.edit_outlined),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
