import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

sealed class LogbookPhotoEditEvent {
  const LogbookPhotoEditEvent();
}

class LogbookPhotoApertureChangedEvent extends LogbookPhotoEditEvent {
  final ApertureValue? aperture;

  const LogbookPhotoApertureChangedEvent(this.aperture);
}

class LogbookPhotoShutterSpeedChangedEvent extends LogbookPhotoEditEvent {
  final ShutterSpeedValue? shutterSpeed;

  const LogbookPhotoShutterSpeedChangedEvent(this.shutterSpeed);
}

class LogbookPhotoNoteChangedEvent extends LogbookPhotoEditEvent {
  final String? note;

  const LogbookPhotoNoteChangedEvent(this.note);
}

class LogbookPhotoEquipmentProfileChangedEvent extends LogbookPhotoEditEvent {
  final String? equipmentProfileId;

  const LogbookPhotoEquipmentProfileChangedEvent(this.equipmentProfileId);
}

class LogbookPhotoFilmChangedEvent extends LogbookPhotoEditEvent {
  final Film? film;

  const LogbookPhotoFilmChangedEvent(this.film);
}

class LogbookPhotoSaveEvent extends LogbookPhotoEditEvent {
  const LogbookPhotoSaveEvent();
}

class LogbookPhotoDeleteEvent extends LogbookPhotoEditEvent {
  const LogbookPhotoDeleteEvent();
}
