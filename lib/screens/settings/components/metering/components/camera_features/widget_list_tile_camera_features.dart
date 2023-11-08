import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/camera_feature.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_switch/widget_dialog_switch.dart';
import 'package:lightmeter/screens/settings/components/shared/iap_list_tile/widget_list_tile_iap.dart';

class CameraFeaturesListTile extends StatelessWidget {
  const CameraFeaturesListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return IAPListTile(
      leading: const Icon(Icons.camera_alt),
      title: Text(S.of(context).cameraFeatures),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => DialogSwitch<CameraFeature>(
            icon: Icons.layers_outlined,
            title: S.of(context).cameraFeatures,
            values: UserPreferencesProvider.cameraConfigOf(context),
            titleAdapter: (context, feature) {
              switch (feature) {
                case CameraFeature.spotMetering:
                  return S.of(context).cameraFeatureSpotMetering;
                case CameraFeature.histogram:
                  return S.of(context).cameraFeatureHistogram;
              }
            },
            subtitleAdapter: (context, feature) {
              switch (feature) {
                case CameraFeature.spotMetering:
                  return S.of(context).cameraFeatureSpotMeteringHint;
                case CameraFeature.histogram:
                  return S.of(context).cameraFeatureHistogramHint;
              }
            },
            onSave: UserPreferencesProvider.of(context).setCameraFeature,
          ),
        );
      },
    );
  }
}
