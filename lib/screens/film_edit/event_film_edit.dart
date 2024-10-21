import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

sealed class FilmEditEvent {
  const FilmEditEvent();
}

class FilmEditNameChangedEvent extends FilmEditEvent {
  final String name;

  const FilmEditNameChangedEvent(this.name);
}

class FilmEditIsoChangedEvent extends FilmEditEvent {
  final IsoValue iso;

  const FilmEditIsoChangedEvent(this.iso);
}

class FilmEditExpChangedEvent extends FilmEditEvent {
  final double exp;

  const FilmEditExpChangedEvent(this.exp);
}

class FilmEditSaveEvent extends FilmEditEvent {
  const FilmEditSaveEvent();
}
