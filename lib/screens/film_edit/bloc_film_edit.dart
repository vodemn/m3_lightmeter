import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/screens/film_edit/event_film_edit.dart';
import 'package:lightmeter/screens/film_edit/state_film_edit.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmEditBloc extends Bloc<FilmEditEvent, FilmEditState> {
  FilmEditBloc(FilmExponential film)
      : super(
          FilmEditState(
            film,
            IsoValue.values.firstWhere((element) => element.value == film.iso),
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
        }
      },
    );
  }

  Future<void> _onNameChanged(FilmEditNameChangedEvent event, Emitter emit) async {}

  Future<void> _onIsoChanged(FilmEditIsoChangedEvent event, Emitter emit) async {
    emit(
      FilmEditState(
        state.film.copyWith(iso: event.iso.value),
        event.iso,
      ),
    );
  }

  Future<void> _onExpChanged(FilmEditExpChangedEvent event, Emitter emit) async {}

  Future<void> _onSave(FilmEditSaveEvent _, Emitter emit) async {}
}
