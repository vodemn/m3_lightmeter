import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/haptics_interactor.dart';

class HapticsListTileBloc extends Cubit<bool> {
  final HapticsInteractor _hapticsInteractor;

  HapticsListTileBloc(
    this._hapticsInteractor,
  ) : super(_hapticsInteractor.isEnabled);

  void onHapticsChange(bool value) {
    _hapticsInteractor.enableHaptics(value);
    if (value) {
      _hapticsInteractor.quickVibration();
    }
    emit(value);
  }
}
