import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/providers/logbook_photos_provider.dart';
import 'package:lightmeter/screens/logbook_photo_edit/event_logbook_photo_edit.dart';
import 'package:lightmeter/screens/logbook_photo_edit/state_logbook_photo_edit.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class LogbookPhotoEditBloc extends Bloc<LogbookPhotoEditEvent, LogbookPhotoEditState> {
  final LogbookPhotosProviderState photosProvider;
  final LogbookPhoto _originalPhoto;
  LogbookPhoto _newPhoto;

  LogbookPhotoEditBloc(
    this.photosProvider,
    LogbookPhoto photo,
  )   : _originalPhoto = photo,
        _newPhoto = photo,
        super(
          LogbookPhotoEditState(
            id: photo.id,
            name: photo.name,
            timestamp: photo.timestamp,
            ev: photo.ev,
            iso: photo.iso,
            nd: photo.nd,
            coordinates: photo.coordinates,
            aperture: photo.apertureValue,
            shutterSpeed: photo.shutterSpeedValue,
            note: photo.note,
            canSave: false,
          ),
        ) {
    on<LogbookPhotoEditEvent>(
      (event, emit) async {
        switch (event) {
          case final LogbookPhotoApertureChangedEvent e:
            await _onApertureChanged(e, emit);
          case final LogbookPhotoShutterSpeedChangedEvent e:
            await _onShutterSpeedChanged(e, emit);
          case final LogbookPhotoNoteChangedEvent e:
            await _onNoteChanged(e, emit);
          case LogbookPhotoSaveEvent():
            await _onSave(event, emit);
          case LogbookPhotoDeleteEvent():
            await _onDelete(event, emit);
        }
      },
    );
  }

  Future<void> _onApertureChanged(LogbookPhotoApertureChangedEvent event, Emitter emit) async {
    _newPhoto = _newPhoto.copyWith(apertureValue: Optional(event.aperture));
    emit(
      state.copyWith(
        aperture: event.aperture,
        canSave: _canSave(),
      ),
    );
  }

  Future<void> _onShutterSpeedChanged(LogbookPhotoShutterSpeedChangedEvent event, Emitter emit) async {
    _newPhoto = _newPhoto.copyWith(shutterSpeedValue: Optional(event.shutterSpeed));
    emit(
      state.copyWith(
        shutterSpeed: event.shutterSpeed,
        canSave: _canSave(),
      ),
    );
  }

  Future<void> _onNoteChanged(LogbookPhotoNoteChangedEvent event, Emitter emit) async {
    _newPhoto = _newPhoto.copyWith(note: event.note);
    emit(
      state.copyWith(
        note: event.note,
        canSave: _canSave(),
      ),
    );
  }

  Future<void> _onSave(LogbookPhotoSaveEvent _, Emitter emit) async {
    emit(state.copyWith(isLoading: true));
    await photosProvider.updateLogbookPhoto(_newPhoto);
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _onDelete(LogbookPhotoDeleteEvent _, Emitter emit) async {
    emit(state.copyWith(isLoading: true));
    await photosProvider.deleteLogbookPhoto(_newPhoto);
    emit(state.copyWith(isLoading: false));
  }

  bool _canSave() {
    return _newPhoto != _originalPhoto;
  }
}
