import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class LogbookPhotoEditState {
  final String id;
  final String name;
  final DateTime timestamp;
  final double ev;
  final int iso;
  final int nd;
  final Film film;
  final Coordinates? coordinates;
  final ApertureValue? aperture;
  final ShutterSpeedValue? shutterSpeed;
  final String? note;
  final bool canSave;
  final bool isLoading;

  const LogbookPhotoEditState({
    required this.id,
    required this.name,
    required this.timestamp,
    required this.ev,
    required this.iso,
    required this.nd,
    required this.film,
    this.coordinates,
    this.aperture,
    this.shutterSpeed,
    this.note,
    required this.canSave,
    this.isLoading = false,
  });

  LogbookPhotoEditState copyWith({
    String? id,
    String? name,
    DateTime? timestamp,
    double? ev,
    int? iso,
    int? nd,
    Film? film,
    Coordinates? coordinates,
    ApertureValue? aperture,
    ShutterSpeedValue? shutterSpeed,
    String? note,
    bool? canSave,
    bool? isLoading,
  }) =>
      LogbookPhotoEditState(
        id: id ?? this.id,
        name: name ?? this.name,
        timestamp: timestamp ?? this.timestamp,
        ev: ev ?? this.ev,
        iso: iso ?? this.iso,
        nd: nd ?? this.nd,
        film: film ?? this.film,
        coordinates: coordinates ?? this.coordinates,
        aperture: aperture ?? this.aperture,
        shutterSpeed: shutterSpeed ?? this.shutterSpeed,
        note: note ?? this.note,
        canSave: canSave ?? this.canSave,
        isLoading: isLoading ?? this.isLoading,
      );
}
