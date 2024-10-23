import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmEditState {
  final String name;
  final IsoValue isoValue;
  final double? exponent;
  final bool canSave;
  final bool isEdit;

  const FilmEditState({
    required this.name,
    required this.isoValue,
    required this.exponent,
    required this.canSave,
    required this.isEdit,
  });
}
