import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/camera_feature.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';

extension DoubleToZoom on double {
  String toZoom(BuildContext context) {
    final showFocalLength = UserPreferencesProvider.cameraFeatureOf(context, CameraFeature.showFocalLength);
    final cameraFocalLength = ServicesProvider.of(context).userPreferencesService.cameraFocalLength;

    if (showFocalLength && cameraFocalLength != null) {
      ServicesProvider.of(context).userPreferencesService.cameraFocalLength;
      final zoomedFocalLength = (this * cameraFocalLength).round();
      return '${zoomedFocalLength}mm';
    } else {
      return 'x${toStringAsFixed(2)}';
    }
  }
}
