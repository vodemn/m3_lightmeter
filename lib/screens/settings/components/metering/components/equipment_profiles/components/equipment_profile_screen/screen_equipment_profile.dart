import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';

import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/components/metering/components/equipment_profiles/components/equipment_profile_screen/components/equipment_profile_container/widget_container_equipment_profile.dart';
import 'package:lightmeter/screens/settings/components/metering/components/equipment_profiles/components/equipment_profile_screen/components/equipment_profile_name_dialog/widget_dialog_equipment_profile_name.dart';
import 'package:lightmeter/screens/shared/icon_placeholder/widget_icon_placeholder.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    profileContainersKeys = EquipmentProfiles.of(context)
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
      slivers: profilesCount == 1
          ? [
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EquipmentProfilesListPlaceholder(onTap: _addProfile),
              )
            ]
          : [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => index > 0 // skip default
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
                  childCount: profilesCount,
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom)),
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
      }
    });
  }

  void _updateProfileAt(EquipmentProfile data, int index) {
    EquipmentProfileProvider.of(context).updateProdile(data);
  }

  void _removeProfileAt(int index) {
    EquipmentProfileProvider.of(context).deleteProfile(EquipmentProfiles.of(context)[index]);
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

class _EquipmentProfilesListPlaceholder extends StatelessWidget {
  final VoidCallback onTap;

  const _EquipmentProfilesListPlaceholder({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.sliverAppBarExpandedHeight),
      child: FractionallySizedBox(
        widthFactor: 1 / 1.618,
        child: Center(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(Dimens.paddingL),
              child: IconPlaceholder(
                icon: Icons.add,
                text: S.of(context).tapToAdd,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
