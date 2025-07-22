import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

sealed class MeteringCommunicationState {
  const MeteringCommunicationState();
}

class InitState extends MeteringCommunicationState {
  const InitState();
}

sealed class SourceState extends MeteringCommunicationState {
  const SourceState();
}

sealed class ScreenState extends MeteringCommunicationState {
  const ScreenState();
}

class MeasureState extends SourceState {
  const MeasureState();
}

class EquipmentProfileChangedState extends SourceState {
  final EquipmentProfile profile;

  const EquipmentProfileChangedState(this.profile);
}

sealed class MeasuredState extends ScreenState {
  final double? ev100;

  const MeasuredState(this.ev100);
}

class MeteringInProgressState extends MeasuredState {
  const MeteringInProgressState(super.ev100);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is MeteringInProgressState && other.ev100 == ev100;
  }

  @override
  int get hashCode => Object.hash(ev100, runtimeType);
}

class MeteringEndedState extends MeasuredState {
  const MeteringEndedState(
    super.ev100, {
    this.photoPath,
  });

  final String? photoPath;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is MeteringEndedState && other.ev100 == ev100 && other.photoPath == photoPath;
  }

  @override
  int get hashCode => Object.hash(runtimeType, ev100, photoPath);
}

class SettingsOpenedState extends SourceState {
  const SettingsOpenedState();
}

class SettingsClosedState extends SourceState {
  const SettingsClosedState();
}
