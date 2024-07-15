enum AppFeature {
  cameraMetering,
  ndFilters,
  theming,
  spotMetering,
  histogram,
  listOfFilms,
  equipmentProfiles,
  timer,
  mainScreenCustomization;

  String get name {
    return toString().replaceAll(runtimeType.toString(), '').replaceAll('.', '');
  }

  bool get isFree {
    switch (this) {
      case AppFeature.cameraMetering:
      case AppFeature.ndFilters:
      case AppFeature.theming:
        return true;
      default:
        return false;
    }
  }
}
