import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import 'components/equipment_profile_section/widget_section_equipment_profile.dart';

class EquipmentProfileScreen extends StatefulWidget {
  const EquipmentProfileScreen({super.key});

  @override
  State<EquipmentProfileScreen> createState() => _EquipmentProfileScreenState();
}

class _EquipmentProfileScreenState extends State<EquipmentProfileScreen> {
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
          separatorBuilder: (context, index) => const SizedBox(height: Dimens.grid16),
          itemCount: EquipmentProfiles.of(context)?.length ?? 0,
          itemBuilder: (_, index) => EquipmentListTilesSection(
            data: EquipmentProfiles.of(context)![index],
            onDelete: () {
              EquipmentProfileProvider.of(context)
                  .deleteProfile(EquipmentProfiles.of(context)![index]);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: EquipmentProfileProvider.of(context).addProfile,
        child: const Icon(Icons.add),
      ),
    );
  }
}
