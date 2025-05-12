enum CameraFeature {
  spotMetering,
  histogram,
  showFocalLength,
}

typedef CameraFeaturesConfig = Map<CameraFeature, bool>;

extension CameraFeaturesConfigJson on CameraFeaturesConfig {
  static CameraFeaturesConfig fromJson(Map<String, dynamic> data) {
    MapEntry<CameraFeature, bool> valueOrBool(CameraFeature feature, {bool defaultValue = true}) => MapEntry(
          feature,
          data[feature.name] as bool? ?? defaultValue,
        );

    return Map.fromEntries(
      [
        valueOrBool(CameraFeature.spotMetering),
        valueOrBool(CameraFeature.histogram, defaultValue: false),
        valueOrBool(CameraFeature.showFocalLength),
      ],
    );
  }

  Map<String, dynamic> toJson() => map((key, value) => MapEntry(key.name, value));
}
