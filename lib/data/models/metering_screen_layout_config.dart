enum MeteringScreenLayoutFeature { equipmentProfiles, extremeExposurePairs, filmPicker }

typedef MeteringScreenLayoutConfig = Map<MeteringScreenLayoutFeature, bool>;

extension MeteringScreenLayoutConfigJson on MeteringScreenLayoutConfig {
  static MeteringScreenLayoutConfig fromJson(Map<String, dynamic> data) => data.map(
        (key, value) => MapEntry(MeteringScreenLayoutFeature.values[int.parse(key)], value as bool),
      );

  Map<String, dynamic> toJson() => map((key, value) => MapEntry(key.index.toString(), value));
}
