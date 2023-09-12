import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

sealed class MeteringEvent {
  const MeteringEvent();
}

class EquipmentProfileChangedEvent extends MeteringEvent {
  final EquipmentProfile equipmentProfileData;

  const EquipmentProfileChangedEvent(this.equipmentProfileData);
}

class FilmChangedEvent extends MeteringEvent {
  final Film film;

  const FilmChangedEvent(this.film);
}

class IsoChangedEvent extends MeteringEvent {
  final IsoValue isoValue;

  const IsoChangedEvent(this.isoValue);
}

class NdChangedEvent extends MeteringEvent {
  final NdValue ndValue;

  const NdChangedEvent(this.ndValue);
}

class MeasureEvent extends MeteringEvent {
  const MeasureEvent();
}

class MeasuredEvent extends MeteringEvent {
  final double ev100;
  final bool isMetering;

  const MeasuredEvent(this.ev100, {required this.isMetering});
}

class MeasureErrorEvent extends MeteringEvent {
  final bool isMetering;

  const MeasureErrorEvent({required this.isMetering});
}

class SettingsOpenedEvent extends MeteringEvent {
  const SettingsOpenedEvent();
}

class SettingsClosedEvent extends MeteringEvent {
  const SettingsClosedEvent();
}
