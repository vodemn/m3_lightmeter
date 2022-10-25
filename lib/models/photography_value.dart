part 'aperture_value.dart';
part 'iso_value.dart';
part 'shutter_speed_value.dart';

enum Stop { full, half, third }

abstract class PhotographyValue<T> {
  final T rawValue;
  final Stop stopType;

  const PhotographyValue(this.rawValue, this.stopType);

  T get value;
}

extension PhotographyValues<T> on List<PhotographyValue<T>> {
  List<PhotographyValue<T>> fullStops() => where((e) => e.stopType == Stop.full).toList();

  List<PhotographyValue<T>> halfStops() => where((e) => e.stopType == Stop.full || e.stopType == Stop.half).toList();

  List<PhotographyValue<T>> thirdStops() => where((e) => e.stopType == Stop.full || e.stopType == Stop.third).toList();
}
