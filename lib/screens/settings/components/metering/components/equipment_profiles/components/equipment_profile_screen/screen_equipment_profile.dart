import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import 'components/equipment_profile_container/widget_container_equipment_profile.dart';
import 'components/equipment_profile_name_dialog/widget_dialog_equipment_profile_name.dart';

class EquipmentProfilesScreen extends StatefulWidget {
  const EquipmentProfilesScreen({super.key});

  @override
  State<EquipmentProfilesScreen> createState() => _EquipmentProfilesScreenState();
}

class _EquipmentProfilesScreenState extends State<EquipmentProfilesScreen> {
  static const maxProfiles = 5; // replace with a constant from iap

  late List<GlobalKey<EquipmentProfileContainerState>> profileContainersKeys = [];
  int get profilesCount => EquipmentProfiles.of(context)?.length ?? 0;

  @override
  void initState() {
    super.initState();
    profileContainersKeys = List.filled(
      EquipmentProfiles.of(context, listen: false)?.length ?? 0,
      GlobalKey<EquipmentProfileContainerState>(),
      growable: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(S.of(context).equipmentProfiles),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView.separated(
          padding: EdgeInsets.fromLTRB(
            Dimens.paddingM,
            Dimens.paddingM,
            Dimens.paddingM,
            Dimens.paddingM +
                MediaQuery.of(context).padding.bottom +
                Dimens.grid56 +
                kFloatingActionButtonMargin,
          ),
          separatorBuilder: (context, index) =>
              index > 0 ? const SizedBox(height: Dimens.grid16) : const SizedBox.shrink(),
          itemCount: profilesCount,
          itemBuilder: (context, index) => index > 0
              ? EquipmentProfileContainer(
                  key: profileContainersKeys[index],
                  data: EquipmentProfiles.of(context)![index],
                  onExpand: () => _keepExpandedAt(index),
                  onUpdate: (profileData) => _updateProfileAt(profileData, index),
                  onDelete: () => _removeProfileAt(index),
                )
              : const SizedBox.shrink(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: profilesCount < maxProfiles
          ? FloatingActionButton(
              onPressed: _addProfile,
              child: const Icon(Icons.add),
            )
          : null,
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
    EquipmentProfileProvider.of(context).deleteProfile(EquipmentProfiles.of(context)![index]);
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
