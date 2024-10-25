import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/screens/film_edit/event_film_edit.dart';
import 'package:lightmeter/screens/film_edit/state_film_edit.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:uuid/uuid.dart';

class FilmEditBloc extends Bloc<FilmEditEvent, FilmEditState> {
  static const _defaultFilm = FilmExponential(name: '', iso: 100, exponent: 1.3);

  final FilmsProviderState filmsProvider;
  final FilmExponential _originalFilm;
  FilmExponential _newFilm;
  final bool _isEdit;

  factory FilmEditBloc(
    FilmsProviderState filmsProvider, {
    required FilmExponential? film,
    required bool isEdit,
  }) =>
      film != null
          ? FilmEditBloc._(
              filmsProvider,
              film,
              isEdit,
            )
          : FilmEditBloc._(
              filmsProvider,
              _defaultFilm,
              isEdit,
            );

  FilmEditBloc._(
    this.filmsProvider,
    FilmExponential film,
    this._isEdit,
  )   : _originalFilm = film,
        _newFilm = film,
        super(
          FilmEditState(
            name: film.name,
            isoValue: IsoValue.values.firstWhere((element) => element.value == film.iso),
            exponent: film.exponent,
            canSave: false,
          ),
        ) {
    on<FilmEditEvent>(
      (event, emit) {
        switch (event) {
          case final FilmEditNameChangedEvent e:
            _onNameChanged(e, emit);
          case final FilmEditIsoChangedEvent e:
            _onIsoChanged(e, emit);
          case final FilmEditExpChangedEvent e:
            _onExpChanged(e, emit);
          case FilmEditSaveEvent():
            _onSave(event, emit);
          case FilmEditDeleteEvent():
            _onDelete(event, emit);
        }
      },
    );
  }

  Future<void> _onNameChanged(FilmEditNameChangedEvent event, Emitter emit) async {
    _newFilm = _newFilm.copyWith(name: event.name);
    emit(
      FilmEditState(
        name: event.name,
        isoValue: state.isoValue,
        exponent: state.exponent,
        canSave: _canSave(event.name, state.exponent),
      ),
    );
  }

  Future<void> _onIsoChanged(FilmEditIsoChangedEvent event, Emitter emit) async {
    _newFilm = _newFilm.copyWith(iso: event.iso.value);
    emit(
      FilmEditState(
        name: state.name,
        isoValue: event.iso,
        exponent: state.exponent,
        canSave: _canSave(state.name, state.exponent),
      ),
    );
  }

  Future<void> _onExpChanged(FilmEditExpChangedEvent event, Emitter emit) async {
    if (event.exponent != null) {
      _newFilm = _newFilm.copyWith(exponent: event.exponent);
    }
    emit(
      FilmEditState(
        name: state.name,
        isoValue: state.isoValue,
        exponent: event.exponent,
        canSave: _canSave(state.name, event.exponent),
      ),
    );
  }

  Future<void> _onSave(FilmEditSaveEvent _, Emitter emit) async {
    if (_isEdit) {
      filmsProvider.updateCustomFilm(
        FilmExponential(
          id: _originalFilm.id,
          name: state.name,
          iso: state.isoValue.value,
          exponent: state.exponent!,
        ),
      );
    } else {
      filmsProvider.addCustomFilm(
        FilmExponential(
          id: const Uuid().v1(),
          name: state.name,
          iso: state.isoValue.value,
          exponent: state.exponent!,
        ),
      );
    }
  }

  Future<void> _onDelete(FilmEditDeleteEvent _, Emitter emit) async {
    filmsProvider.deleteCustomFilm(_originalFilm);
  }

  bool _canSave(String name, double? exponent) {
    return name.isNotEmpty && exponent != null && _newFilm != _originalFilm;
  }
}
