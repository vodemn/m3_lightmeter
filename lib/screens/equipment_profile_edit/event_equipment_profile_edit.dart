import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

sealed class EquipmentProfileEditEvent {
  const EquipmentProfileEditEvent();
}

class EquipmentProfileNameChangedEvent extends EquipmentProfileEditEvent {
  final String name;

  const EquipmentProfileNameChangedEvent(this.name);
}

class EquipmentProfileIsoValuesChangedEvent extends EquipmentProfileEditEvent {
  final List<IsoValue> isoValues;

  const EquipmentProfileIsoValuesChangedEvent(this.isoValues);
}

class EquipmentProfileNdValuesChangedEvent extends EquipmentProfileEditEvent {
  final List<NdValue> ndValues;

  const EquipmentProfileNdValuesChangedEvent(this.ndValues);
}

class EquipmentProfileApertureValuesChangedEvent extends EquipmentProfileEditEvent {
  final List<ApertureValue> apertureValues;

  const EquipmentProfileApertureValuesChangedEvent(this.apertureValues);
}

class EquipmentProfileShutterSpeedValuesChangedEvent extends EquipmentProfileEditEvent {
  final List<ShutterSpeedValue> shutterSpeedValues;

  const EquipmentProfileShutterSpeedValuesChangedEvent(this.shutterSpeedValues);
}

class EquipmentProfileLensZoomChangedEvent extends EquipmentProfileEditEvent {
  final double lensZoom;

  const EquipmentProfileLensZoomChangedEvent(this.lensZoom);
}

class EquipmentProfileSaveEvent extends EquipmentProfileEditEvent {
  const EquipmentProfileSaveEvent();
}

class EquipmentProfileCopyEvent extends EquipmentProfileEditEvent {
  const EquipmentProfileCopyEvent();
}

class EquipmentProfileDeleteEvent extends EquipmentProfileEditEvent {
  const EquipmentProfileDeleteEvent();
}
