import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';

class VolumeActionsListTileBloc extends Cubit<bool> {
  final SettingsInteractor _settingsInteractor;

  VolumeActionsListTileBloc(
    this._settingsInteractor,
  ) : super(_settingsInteractor.volumeAction == VolumeAction.shutter);

  void onVolumeActionChanged(bool value) {
    _settingsInteractor.setVolumeAction(value ? VolumeAction.shutter : VolumeAction.none);

    // while in settings we allow system to handle volume
    // so that volume keys action works only when necessary - on the metering screen
    _settingsInteractor.disableVolumeHandling();
    emit(value);
  }
}
