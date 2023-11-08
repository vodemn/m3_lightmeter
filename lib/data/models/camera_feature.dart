enum CameraFeature {
  histogram,
  spotMetering,
}

typedef CameraFeaturesConfig = Map<CameraFeature, bool>;

extension CameraFeaturesConfigJson on CameraFeaturesConfig {
  static CameraFeaturesConfig fromJson(Map<String, dynamic> data) =>
      <CameraFeature, bool>{for (final f in CameraFeature.values) f: data[f.name] as bool? ?? false};

  Map<String, dynamic> toJson() => map((key, value) => MapEntry(key.name, value));
}
