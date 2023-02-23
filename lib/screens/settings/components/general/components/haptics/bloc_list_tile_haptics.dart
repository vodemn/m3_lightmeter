import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';

class HapticsListTileBloc extends Cubit<bool> {
  final SettingsInteractor _settingsInteractor;

  HapticsListTileBloc(
    this._settingsInteractor,
  ) : super(_settingsInteractor.isHapticsEnabled);

  void onHapticsChanged(bool value) {
    _settingsInteractor.enableHaptics(value);
    emit(value);
  }
}
