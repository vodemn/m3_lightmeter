import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/camera_feature.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_switch/widget_dialog_switch.dart';

class CameraFeaturesListTile extends StatelessWidget {
  const CameraFeaturesListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.camera_enhance_outlined),
      title: Text(S.of(context).cameraFeatures),
      onTap: () {
        UserPreferencesProvider.cameraConfigOf(context).entries.map(
              (entry) => DialogSwitchListItem(
                value: CameraFeature.spotMetering,
                title: S.of(context).cameraFeatureSpotMetering,
                subtitle: S.of(context).cameraFeatureSpotMeteringHint,
                initialValue: UserPreferencesProvider.cameraFeatureOf(context, CameraFeature.spotMetering),
                isProRequired: true,
              ),
            );
        showDialog(
          context: context,
          builder: (_) => DialogSwitch<CameraFeature>(
            icon: Icons.camera_enhance_outlined,
            title: S.of(context).cameraFeatures,
            items: [
              DialogSwitchListItem(
                value: CameraFeature.showFocalLength,
                title: S.of(context).cameraFeaturesShowFocalLength,
                subtitle: S.of(context).cameraFeaturesShowFocalLengthHint,
                initialValue: UserPreferencesProvider.cameraFeatureOf(context, CameraFeature.showFocalLength),
                isEnabled: ServicesProvider.of(context).userPreferencesService.cameraFocalLength != null,
              ),
              DialogSwitchListItem(
                value: CameraFeature.spotMetering,
                title: S.of(context).cameraFeatureSpotMetering,
                subtitle: S.of(context).cameraFeatureSpotMeteringHint,
                initialValue: UserPreferencesProvider.cameraFeatureOf(context, CameraFeature.spotMetering),
                isProRequired: true,
              ),
              DialogSwitchListItem(
                value: CameraFeature.histogram,
                title: S.of(context).cameraFeatureHistogram,
                subtitle: S.of(context).cameraFeatureHistogramHint,
                initialValue: UserPreferencesProvider.cameraFeatureOf(context, CameraFeature.histogram),
                isProRequired: true,
              ),
            ],
            onSave: UserPreferencesProvider.of(context).setCameraFeature,
          ),
        );
      },
    );
  }
}
