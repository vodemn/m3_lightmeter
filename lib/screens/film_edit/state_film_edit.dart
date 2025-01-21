import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmEditState {
  final String name;
  final IsoValue isoValue;
  final double? exponent;
  final bool canSave;
  final bool isLoading;

  const FilmEditState({
    required this.name,
    required this.isoValue,
    required this.exponent,
    required this.canSave,
    this.isLoading = false,
  });

  FilmEditState copyWith({
    String? name,
    IsoValue? isoValue,
    double? exponent,
    bool? canSave,
    bool? isLoading,
  }) =>
      FilmEditState(
        name: name ?? this.name,
        isoValue: isoValue ?? this.isoValue,
        exponent: exponent ?? this.exponent,
        canSave: canSave ?? this.canSave,
        isLoading: isLoading ?? this.isLoading,
      );
}
