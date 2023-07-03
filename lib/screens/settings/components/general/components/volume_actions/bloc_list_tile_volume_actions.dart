import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';

class VolumeActionsListTileBloc extends Cubit<VolumeAction> {
  final SettingsInteractor _settingsInteractor;

  VolumeActionsListTileBloc(
    this._settingsInteractor,
  ) : super(_settingsInteractor.volumeAction);

  void onVolumeActionChanged(VolumeAction value) {
    _settingsInteractor.setVolumeAction(value);
    emit(value);
  }
}
