abstract class LightSensorContainerEvent {
  const LightSensorContainerEvent();
}

class LuxMeteringEvent extends LightSensorContainerEvent {
  final int lux;

  const LuxMeteringEvent(this.lux);
}
