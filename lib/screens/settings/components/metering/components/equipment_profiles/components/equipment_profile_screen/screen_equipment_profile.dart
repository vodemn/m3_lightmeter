import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import 'components/equipment_profile_container/widget_container_equipment_profile.dart';
import 'components/equipment_profile_name_dialog/widget_dialog_equipment_profile_name.dart';

class EquipmentProfilesScreen extends StatefulWidget {
  const EquipmentProfilesScreen({super.key});

  @override
  State<EquipmentProfilesScreen> createState() => _EquipmentProfilesScreenState();
}

class _EquipmentProfilesScreenState extends State<EquipmentProfilesScreen> {
  static const maxProfiles = 5 + 1; // replace with a constant from iap

  late List<GlobalKey<EquipmentProfileContainerState>> profileContainersKeys = [];
  int get profilesCount => EquipmentProfiles.of(context).length;

  @override
  void initState() {
    super.initState();
    profileContainersKeys = EquipmentProfiles.of(context, listen: false)
        .map((e) => GlobalKey<EquipmentProfileContainerState>(debugLabel: e.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SliverScreen(
      title: S.of(context).equipmentProfiles,
      appBarActions: [
        if (profilesCount < maxProfiles)
          IconButton(
            onPressed: _addProfile,
            icon: const Icon(Icons.add),
          ),
        IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.close),
        ),
      ],
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => index > 0
                ? Padding(
                    padding: EdgeInsets.fromLTRB(
                      Dimens.paddingM,
                      index == 0 ? Dimens.paddingM : 0,
                      Dimens.paddingM,
                      Dimens.paddingM,
                    ),
                    child: EquipmentProfileContainer(
                      key: profileContainersKeys[index],
                      data: EquipmentProfiles.of(context)[index],
                      onExpand: () => _keepExpandedAt(index),
                      onUpdate: (profileData) => _updateProfileAt(profileData, index),
                      onDelete: () => _removeProfileAt(index),
                    ),
                  )
                : const SizedBox.shrink(),
            childCount: profileContainersKeys.length,
          ),
        ),
      ],
    );
  }

  void _addProfile() {
    showDialog<String>(
      context: context,
      builder: (_) => const EquipmentProfileNameDialog(),
    ).then((value) {
      if (value != null) {
        EquipmentProfileProvider.of(context).addProfile(value);
        profileContainersKeys.add(GlobalKey<EquipmentProfileContainerState>());
      }
    });
  }

  void _updateProfileAt(EquipmentProfileData data, int index) {
    EquipmentProfileProvider.of(context).updateProdile(data);
  }

  void _removeProfileAt(int index) {
    EquipmentProfileProvider.of(context).deleteProfile(EquipmentProfiles.of(context)[index]);
    profileContainersKeys.removeAt(index);
  }

  void _keepExpandedAt(int index) {
    profileContainersKeys.getRange(0, index).forEach((element) {
      element.currentState?.collapse();
    });
    profileContainersKeys.getRange(index + 1, profilesCount).forEach((element) {
      element.currentState?.collapse();
    });
  }
}
