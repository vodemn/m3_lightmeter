import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';

class CaffeineListTileBloc extends Cubit<bool> {
  final SettingsInteractor _settingsInteractor;

  CaffeineListTileBloc(
    this._settingsInteractor,
  ) : super(_settingsInteractor.isCaffeineEnabled);

  void onCaffeineChanged(bool value) {
    _settingsInteractor.enableCaffeine(value);
    emit(value);
  }
}
