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

class LogbookPhotoSaveEvent extends LogbookPhotoEditEvent {
  const LogbookPhotoSaveEvent();
}

class LogbookPhotoDeleteEvent extends LogbookPhotoEditEvent {
  const LogbookPhotoDeleteEvent();
}
