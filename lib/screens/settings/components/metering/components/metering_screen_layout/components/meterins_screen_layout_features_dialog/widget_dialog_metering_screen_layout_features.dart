import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/dimens.dart';

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
            ...MeteringScreenLayoutFeature.values.map(
              (f) => SwitchListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: Dimens.dialogTitlePadding.left),
                title: Text(_toStringLocalized(context, f)),
                value: _features[f]!,
                onChanged: (value) {
                  setState(() {
                    _features.update(f, (_) => value);
                  });
                },
              ),
            ),
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
            UserPreferencesProvider.of(context).setMeteringScreenLayout(_features);
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).save),
        ),
      ],
    );
  }

  String _toStringLocalized(BuildContext context, MeteringScreenLayoutFeature feature) {
    switch (feature) {
      case MeteringScreenLayoutFeature.extremeExposurePairs:
        return S.of(context).meteringScreenFeatureExtremeExposurePairs;
      case MeteringScreenLayoutFeature.filmPicker:
        return S.of(context).meteringScreenFeatureFilmPicker;
      case MeteringScreenLayoutFeature.histogram:
        return S.of(context).meteringScreenFeatureHistogram;
    }
  }
}
