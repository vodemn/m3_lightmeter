import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';

class TimerListTileBloc extends Cubit<bool> {
  final SettingsInteractor _settingsInteractor;

  TimerListTileBloc(
    this._settingsInteractor,
  ) : super(_settingsInteractor.isAutostartTimerEnabled);

  void onChanged(bool value) {
    _settingsInteractor.enableAutostartTimer(value);
    emit(value);
  }
}
