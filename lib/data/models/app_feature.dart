import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';

enum AppFeature {
  reflectedLightMetering,
  incidedntLightMetering,
  isoAndNdValues,
  themeEngine,
  spotMeteringAndHistogram,
  focalLength,
  listOfFilms,
  customFilms,
  equipmentProfiles,
  timer,
  mainScreenCustomization;

  static List<AppFeature> get androidFeatures => values;

  static List<AppFeature> get iosFeatures => values.where((f) => f != AppFeature.incidedntLightMetering).toList();

  String name(BuildContext context) {
    switch (this) {
      case AppFeature.reflectedLightMetering:
        return S.of(context).featureReflectedLightMetering;
      case AppFeature.incidedntLightMetering:
        return S.of(context).featureIncidentLightMetering;
      case AppFeature.isoAndNdValues:
        return S.of(context).featureIsoAndNdValues;
      case AppFeature.themeEngine:
        return S.of(context).featureTheme;
      case AppFeature.spotMeteringAndHistogram:
        return S.of(context).featureSpotMeteringAndHistorgram;
      case AppFeature.focalLength:
        return S.of(context).featureFocalLength35mm;
      case AppFeature.listOfFilms:
        return S.of(context).featureListOfFilms;
      case AppFeature.customFilms:
        return S.of(context).featureCustomFilms;
      case AppFeature.equipmentProfiles:
        return S.of(context).featureEquipmentProfiles;
      case AppFeature.timer:
        return S.of(context).featureTimer;
      case AppFeature.mainScreenCustomization:
        return S.of(context).featureMeteringScreenLayout;
    }
  }

  bool get isFree {
    switch (this) {
      case AppFeature.reflectedLightMetering:
      case AppFeature.incidedntLightMetering:
      case AppFeature.isoAndNdValues:
      case AppFeature.themeEngine:
        return true;
      default:
        return false;
    }
  }
}
