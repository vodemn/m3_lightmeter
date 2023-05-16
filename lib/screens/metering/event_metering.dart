import 'package:lightmeter/data/models/film.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

abstract class MeteringEvent {
  const MeteringEvent();
}

class StopTypeChangedEvent extends MeteringEvent {
  final StopType stopType;

  const StopTypeChangedEvent(this.stopType);
}

class EquipmentProfileChangedEvent extends MeteringEvent {
  final EquipmentProfileData equipmentProfileData;

  const EquipmentProfileChangedEvent(this.equipmentProfileData);
}

class FilmChangedEvent extends MeteringEvent {
  final Film data;

  const FilmChangedEvent(this.data);
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

  const MeasuredEvent(this.ev100);
}

class MeasureErrorEvent extends MeteringEvent {
  const MeasureErrorEvent();
}
