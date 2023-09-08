import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

class MeteringScreenLayoutFeaturesDialog extends StatefulWidget {
  const MeteringScreenLayoutFeaturesDialog({super.key});

  @override
  State<MeteringScreenLayoutFeaturesDialog> createState() =>
      _MeteringScreenLayoutFeaturesDialogState();
}

class _MeteringScreenLayoutFeaturesDialogState extends State<MeteringScreenLayoutFeaturesDialog> {
  late final _features =
      MeteringScreenLayoutConfig.from(UserPreferencesProvider.meteringScreenConfigOf(context));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.layers_outlined),
      titlePadding: Dimens.dialogIconTitlePadding,
      title: Text(S.of(context).meteringScreenLayout),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingL),
              child: Text(S.of(context).meteringScreenLayoutHint),
            ),
            const SizedBox(height: Dimens.grid16),
            _featureListTile(MeteringScreenLayoutFeature.equipmentProfiles),
            _featureListTile(MeteringScreenLayoutFeature.extremeExposurePairs),
            _featureListTile(MeteringScreenLayoutFeature.filmPicker),
            _featureListTile(MeteringScreenLayoutFeature.histogram),
          ],
        ),
      ),
      actionsPadding: Dimens.dialogActionsPadding,
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(S.of(context).cancel),
        ),
        TextButton(
          onPressed: () {
            if (!_features[MeteringScreenLayoutFeature.equipmentProfiles]!) {
              EquipmentProfileProvider.of(context).setProfile(EquipmentProfiles.of(context).first);
            }
            UserPreferencesProvider.of(context).setMeteringScreenLayout(_features);
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).save),
        ),
      ],
    );
  }

  Widget _featureListTile(MeteringScreenLayoutFeature f) {
    return SwitchListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: Dimens.dialogTitlePadding.left),
      title: Text(_toStringLocalized(context, f)),
      value: _features[f]!,
      onChanged: (value) {
        setState(() {
          _features.update(f, (_) => value);
        });
      },
    );
  }

  String _toStringLocalized(BuildContext context, MeteringScreenLayoutFeature feature) {
    switch (feature) {
      case MeteringScreenLayoutFeature.equipmentProfiles:
        return S.of(context).equipmentProfiles;
      case MeteringScreenLayoutFeature.extremeExposurePairs:
        return S.of(context).meteringScreenFeatureExtremeExposurePairs;
      case MeteringScreenLayoutFeature.filmPicker:
        return S.of(context).meteringScreenFeatureFilmPicker;
      case MeteringScreenLayoutFeature.histogram:
        return S.of(context).meteringScreenFeatureHistogram;
    }
  }
}
