import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/components/metering/components/equipment_profiles/components/equipment_profile_screen/components/equipment_profile_container/widget_container_equipment_profile.dart';
import 'package:lightmeter/screens/settings/components/metering/components/equipment_profiles/components/equipment_profile_screen/components/equipment_profile_name_dialog/widget_dialog_equipment_profile_name.dart';
import 'package:lightmeter/screens/shared/icon_placeholder/widget_icon_placeholder.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfilesScreen extends StatefulWidget {
  const EquipmentProfilesScreen({super.key});

  @override
  State<EquipmentProfilesScreen> createState() => _EquipmentProfilesScreenState();
}

class _EquipmentProfilesScreenState extends State<EquipmentProfilesScreen> {
  final Map<String, GlobalKey<EquipmentProfileContainerState>> keysMap = {};
  int get profilesCount => keysMap.length;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateProfilesKeys();
  }

  @override
  Widget build(BuildContext context) {
    return SliverScreen(
      title: S.of(context).equipmentProfiles,
      appBarActions: [
        IconButton(
          onPressed: _addProfile,
          icon: const Icon(Icons.add),
          tooltip: S.of(context).tooltipAdd,
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
                  (context, index) {
                    if (index == 0) {
                      // skip default profile
                      return const SizedBox.shrink();
                    }

                    final profile = EquipmentProfiles.of(context)[index];
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        Dimens.paddingM,
                        index == 0 ? Dimens.paddingM : 0,
                        Dimens.paddingM,
                        Dimens.paddingM,
                      ),
                      child: EquipmentProfileContainer(
                        key: keysMap[profile.id],
                        data: profile,
                        onExpand: () => _keepExpandedAt(index),
                        onUpdate: _updateProfileAt,
                        onCopy: () => _addProfile(profile),
                        onDelete: () => _removeProfileAt(profile),
                      ),
                    );
                  },
                  childCount: EquipmentProfiles.of(context).length,
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom)),
            ],
    );
  }

  void _addProfile([EquipmentProfile? copyFrom]) {
    showDialog<String>(
      context: context,
      builder: (_) => const EquipmentProfileNameDialog(),
    ).then((name) {
      if (name != null) {
        EquipmentProfileProvider.of(context).addProfile(name, copyFrom);
      }
    });
  }

  void _updateProfileAt(EquipmentProfile data) {
    EquipmentProfileProvider.of(context).updateProfile(data);
  }

  void _removeProfileAt(EquipmentProfile data) {
    EquipmentProfileProvider.of(context).deleteProfile(data);
  }

  void _keepExpandedAt(int index) {
    keysMap.values.toList().getRange(0, index).forEach((element) {
      element.currentState?.collapse();
    });
    keysMap.values.toList().getRange(index + 1, profilesCount).forEach((element) {
      element.currentState?.collapse();
    });
  }

  void _updateProfilesKeys() {
    final profiles = EquipmentProfiles.of(context);
    if (profiles.length > keysMap.length) {
      // profile added
      final List<String> idsToAdd = [];
      for (final profile in profiles) {
        if (!keysMap.keys.contains(profile.id)) idsToAdd.add(profile.id);
      }
      for (final id in idsToAdd) {
        keysMap[id] = GlobalKey<EquipmentProfileContainerState>(debugLabel: id);
      }
      idsToAdd.clear();
    } else if (profiles.length < keysMap.length) {
      // profile deleted
      final List<String> idsToDelete = [];
      for (final id in keysMap.keys) {
        if (!profiles.any((p) => p.id == id)) idsToDelete.add(id);
      }
      idsToDelete.forEach(keysMap.remove);
      idsToDelete.clear();
    } else {
      // profile updated, no need to updated keys
    }
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
