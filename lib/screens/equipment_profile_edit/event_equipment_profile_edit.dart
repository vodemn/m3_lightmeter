import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

sealed class IEquipmentProfileEditEvent<T extends IEquipmentProfile> {
  const IEquipmentProfileEditEvent();
}

class EquipmentProfileNameChangedEvent<T extends IEquipmentProfile> extends IEquipmentProfileEditEvent<T> {
  final String name;

  const EquipmentProfileNameChangedEvent(this.name);
}

class EquipmentProfileIsoValuesChangedEvent<T extends IEquipmentProfile> extends IEquipmentProfileEditEvent<T> {
  final List<IsoValue> isoValues;

  const EquipmentProfileIsoValuesChangedEvent(this.isoValues);
}

class EquipmentProfileNdValuesChangedEvent<T extends IEquipmentProfile> extends IEquipmentProfileEditEvent<T> {
  final List<NdValue> ndValues;

  const EquipmentProfileNdValuesChangedEvent(this.ndValues);
}

class EquipmentProfileApertureValuesChangedEvent extends IEquipmentProfileEditEvent<EquipmentProfile> {
  final List<ApertureValue> apertureValues;

  const EquipmentProfileApertureValuesChangedEvent(this.apertureValues);
}

class EquipmentProfileApertureValueChangedEvent extends IEquipmentProfileEditEvent<PinholeEquipmentProfile> {
  final double? aperture;

  const EquipmentProfileApertureValueChangedEvent(this.aperture);
}

class EquipmentProfileShutterSpeedValuesChangedEvent extends IEquipmentProfileEditEvent<EquipmentProfile> {
  final List<ShutterSpeedValue> shutterSpeedValues;

  const EquipmentProfileShutterSpeedValuesChangedEvent(this.shutterSpeedValues);
}

class EquipmentProfileLensZoomChangedEvent<T extends IEquipmentProfile> extends IEquipmentProfileEditEvent<T> {
  final double lensZoom;

  const EquipmentProfileLensZoomChangedEvent(this.lensZoom);
}

class EquipmentProfileExposureOffsetChangedEvent<T extends IEquipmentProfile> extends IEquipmentProfileEditEvent<T> {
  final double exposureOffset;

  const EquipmentProfileExposureOffsetChangedEvent(this.exposureOffset);
}

class EquipmentProfileSaveEvent<T extends IEquipmentProfile> extends IEquipmentProfileEditEvent<T> {
  const EquipmentProfileSaveEvent();
}

class EquipmentProfileCopyEvent<T extends IEquipmentProfile> extends IEquipmentProfileEditEvent<T> {
  const EquipmentProfileCopyEvent();
}

class EquipmentProfileDeleteEvent<T extends IEquipmentProfile> extends IEquipmentProfileEditEvent<T> {
  const EquipmentProfileDeleteEvent();
}
