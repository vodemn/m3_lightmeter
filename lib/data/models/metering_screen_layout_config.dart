enum MeteringScreenLayoutFeature {
  extremeExposurePairs,
  filmPicker,
  equipmentProfiles,
}

typedef MeteringScreenLayoutConfig = Map<MeteringScreenLayoutFeature, bool>;

extension MeteringScreenLayoutConfigJson on MeteringScreenLayoutConfig {
  static MeteringScreenLayoutConfig fromJson(Map<String, dynamic> data) =>
      <MeteringScreenLayoutFeature, bool>{
        for (final f in MeteringScreenLayoutFeature.values)
          f: data[f.index.toString()] as bool? ?? true
      };

  Map<String, dynamic> toJson() => map((key, value) => MapEntry(key.index.toString(), value));
}
