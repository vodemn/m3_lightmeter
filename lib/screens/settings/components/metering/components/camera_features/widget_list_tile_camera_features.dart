import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/camera_feature.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_switch/widget_dialog_switch.dart';
import 'package:lightmeter/screens/settings/components/shared/iap_list_tile/widget_list_tile_iap.dart';

class CameraFeaturesListTile extends StatelessWidget {
  const CameraFeaturesListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return IAPListTile(
      leading: const Icon(Icons.camera_alt_outlined),
      title: Text(S.of(context).cameraFeatures),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => DialogSwitch<CameraFeature>(
            icon: Icons.camera_alt_outlined,
            title: S.of(context).cameraFeatures,
            values: UserPreferencesProvider.cameraConfigOf(context),
            enabledAdapter: (feature) => switch (feature) {
              CameraFeature.spotMetering => true,
              CameraFeature.histogram => true,
              CameraFeature.showFocalLength =>
                ServicesProvider.of(context).userPreferencesService.cameraFocalLength != null,
            },
            titleAdapter: (context, feature) => switch (feature) {
              CameraFeature.spotMetering => S.of(context).cameraFeatureSpotMetering,
              CameraFeature.histogram => S.of(context).cameraFeatureHistogram,
              CameraFeature.showFocalLength => S.of(context).cameraFeaturesShowFocalLength,
            },
            subtitleAdapter: (context, feature) => switch (feature) {
              CameraFeature.spotMetering => S.of(context).cameraFeatureSpotMeteringHint,
              CameraFeature.histogram => S.of(context).cameraFeatureHistogramHint,
              CameraFeature.showFocalLength => S.of(context).cameraFeaturesShowFocalLengthHint,
            },
            onSave: UserPreferencesProvider.of(context).setCameraFeature,
          ),
        );
      },
    );
  }
}
