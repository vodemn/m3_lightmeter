import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

class EquipmentProfilesListTile extends StatelessWidget {
  const EquipmentProfilesListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.camera),
      title: Text(S.of(context).equipmentProfiles),
      onTap: () {
        showEquipmentProfilesDialog(
          context,
          EquipmentProfileSectionLocalizationData(
            isoValues: S.of(context).isoValues,
            isoValuesFilterDescription: S.of(context).isoValuesFilterDescription,
            ndValues: S.of(context).ndFilters,
            ndValuesFilterDescription: S.of(context).ndFiltersFilterDescription,
            apertureValues: S.of(context).apertureValues,
            apertureValuesFilterDescription: S.of(context).apertureValuesFilterDescription,
            shutterSpeedValues: S.of(context).shutterSpeedValues,
            shutterSpeedValuesFilterDescription: S.of(context).shutterSpeedValuesFilterDescription,
            dialogFilterLocalizationData: DialogFilterLocalizationData(
              cancel: S.of(context).cancel,
              save: S.of(context).save,
            ),
          ),
        );
      },
    );
  }
}
