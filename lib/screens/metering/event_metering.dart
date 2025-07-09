import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

sealed class MeteringEvent {
  const MeteringEvent();
}

class EquipmentProfileChangedEvent extends MeteringEvent {
  final EquipmentProfile equipmentProfileData;

  const EquipmentProfileChangedEvent(this.equipmentProfileData);
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
  final String? photoPath;

  const MeasuredEvent(
    this.ev100, {
    required this.isMetering,
    this.photoPath,
  });
}

class MeasureErrorEvent extends MeteringEvent {
  final bool isMetering;

  const MeasureErrorEvent({required this.isMetering});
}

class ScreenOnTopOpenedEvent extends MeteringEvent {
  const ScreenOnTopOpenedEvent();
}

class ScreenOnTopClosedEvent extends MeteringEvent {
  const ScreenOnTopClosedEvent();
}
