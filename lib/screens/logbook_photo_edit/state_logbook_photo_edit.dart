import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class LogbookPhotoEditState {
  final String id;
  final String name;
  final DateTime timestamp;
  final double ev;
  final int iso;
  final int nd;
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
    this.coordinates,
    this.aperture,
    this.shutterSpeed,
    this.note,
    required this.canSave,
    this.isLoading = false,
  });

  LogbookPhotoEditState copyWith({
    String? name,
    Optional<ApertureValue>? aperture,
    Optional<ShutterSpeedValue>? shutterSpeed,
    String? note,
    bool? canSave,
    bool? isLoading,
  }) =>
      LogbookPhotoEditState(
        id: id,
        name: name ?? this.name,
        timestamp: timestamp,
        ev: ev,
        iso: iso,
        nd: nd,
        aperture: aperture != null ? aperture.value : this.aperture,
        shutterSpeed: shutterSpeed != null ? shutterSpeed.value : this.shutterSpeed,
        note: note ?? this.note,
        canSave: canSave ?? this.canSave,
        isLoading: isLoading ?? this.isLoading,
      );
}
