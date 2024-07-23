import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/films_provider.dart';

enum AppFeature {
  reflectedLightMetering,
  incidedntLightMetering,
  isoAndNdValues,
  themeEngine,
  spotMetering,
  histogram,
  listOfFilms,
  equipmentProfiles,
  timer,
  mainScreenCustomization;

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
      case AppFeature.spotMetering:
        return S.of(context).featureSpotMetering;
      case AppFeature.histogram:
        return S.of(context).featureHistogram;
      case AppFeature.listOfFilms:
        return S.of(context).featureListOfFilms;
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
