enum MeteringScreenLayoutFeature {
  extremeExposurePairs, // 0
  filmPicker, // 1
  equipmentProfiles, // 3
}

typedef MeteringScreenLayoutConfig = Map<MeteringScreenLayoutFeature, bool>;

extension MeteringScreenLayoutConfigJson on MeteringScreenLayoutConfig {
  static MeteringScreenLayoutConfig fromJson(Map<String, dynamic> data) {
    int migratedIndex(MeteringScreenLayoutFeature feature) {
      switch (feature) {
        case MeteringScreenLayoutFeature.extremeExposurePairs:
          return 0;
        case MeteringScreenLayoutFeature.filmPicker:
          return 1;
        case MeteringScreenLayoutFeature.equipmentProfiles:
          return 3;
      }
    }

    return <MeteringScreenLayoutFeature, bool>{
      for (final f in MeteringScreenLayoutFeature.values)
        f: (data[migratedIndex(f).toString()] ?? data[f.name]) as bool? ?? true,
    };
  }

  Map<String, dynamic> toJson() => map((key, value) => MapEntry(key.name, value));
}
