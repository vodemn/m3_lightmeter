import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/screens/equipment_profile_edit/event_equipment_profile_edit.dart';
import 'package:lightmeter/screens/equipment_profile_edit/state_equipment_profile_edit.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:uuid/uuid.dart';

class EquipmentProfileEditBloc extends Bloc<EquipmentProfileEditEvent, EquipmentProfileEditState> {
  static const EquipmentProfile _defaultProfile = EquipmentProfile(
    id: '',
    name: '',
    apertureValues: ApertureValue.values,
    ndValues: NdValue.values,
    shutterSpeedValues: ShutterSpeedValue.values,
    isoValues: IsoValue.values,
  );

  final EquipmentProfileProviderState profilesProvider;
  final EquipmentProfile _originalEquipmentProfile;
  EquipmentProfile _newEquipmentProfile;
  final bool _isEdit;

  factory EquipmentProfileEditBloc(
    EquipmentProfileProviderState profilesProvider, {
    required EquipmentProfile? profile,
    required bool isEdit,
  }) =>
      profile != null
          ? EquipmentProfileEditBloc._(
              profilesProvider,
              profile,
              isEdit,
            )
          : EquipmentProfileEditBloc._(
              profilesProvider,
              _defaultProfile,
              isEdit,
            );

  EquipmentProfileEditBloc._(
    this.profilesProvider,
    EquipmentProfile profile,
    this._isEdit,
  )   : _originalEquipmentProfile = profile,
        _newEquipmentProfile = profile,
        super(
          EquipmentProfileEditState(
            name: profile.name,
            apertureValues: profile.apertureValues,
            shutterSpeedValues: profile.shutterSpeedValues,
            isoValues: profile.isoValues,
            ndValues: profile.ndValues,
            lensZoom: profile.lensZoom,
            canSave: false,
          ),
        ) {
    on<EquipmentProfileEditEvent>(
      (event, emit) async {
        switch (event) {
          case final EquipmentProfileNameChangedEvent e:
            await _onNameChanged(e, emit);
          case final EquipmentProfileApertureValuesChangedEvent e:
            await _onApertureValuesChanged(e, emit);
          case final EquipmentProfileShutterSpeedValuesChangedEvent e:
            await _onShutterSpeedValuesChanged(e, emit);
          case final EquipmentProfileIsoValuesChangedEvent e:
            await _onIsoValuesChanged(e, emit);
          case final EquipmentProfileNdValuesChangedEvent e:
            await _onNdValuesChanged(e, emit);
          case final EquipmentProfileLensZoomChangedEvent e:
            await _onLensZoomChanged(e, emit);
          case EquipmentProfileSaveEvent():
            await _onSave(event, emit);
          case EquipmentProfileDeleteEvent():
            await _onDelete(event, emit);
        }
      },
    );
  }

  Future<void> _onNameChanged(EquipmentProfileNameChangedEvent event, Emitter emit) async {
    _newEquipmentProfile = _newEquipmentProfile.copyWith(name: event.name);
    emit(
      state.copyWith(
        name: event.name,
        canSave: _canSave(event.name, state.lensZoom),
      ),
    );
  }

  Future<void> _onApertureValuesChanged(EquipmentProfileApertureValuesChangedEvent event, Emitter emit) async {
    _newEquipmentProfile = _newEquipmentProfile.copyWith(apertureValues: event.apertureValues);
    emit(state.copyWith(apertureValues: event.apertureValues));
  }

  Future<void> _onShutterSpeedValuesChanged(EquipmentProfileShutterSpeedValuesChangedEvent event, Emitter emit) async {
    _newEquipmentProfile = _newEquipmentProfile.copyWith(shutterSpeedValues: event.shutterSpeedValues);
    emit(state.copyWith(shutterSpeedValues: event.shutterSpeedValues));
  }

  Future<void> _onIsoValuesChanged(EquipmentProfileIsoValuesChangedEvent event, Emitter emit) async {
    _newEquipmentProfile = _newEquipmentProfile.copyWith(isoValues: event.isoValues);
    emit(state.copyWith(isoValues: event.isoValues));
  }

  Future<void> _onNdValuesChanged(EquipmentProfileNdValuesChangedEvent event, Emitter emit) async {
    _newEquipmentProfile = _newEquipmentProfile.copyWith(ndValues: event.ndValues);
    emit(state.copyWith(ndValues: event.ndValues));
  }

  Future<void> _onLensZoomChanged(EquipmentProfileLensZoomChangedEvent event, Emitter emit) async {
    _newEquipmentProfile = _newEquipmentProfile.copyWith(lensZoom: event.lensZoom);
    emit(
      state.copyWith(
        lensZoom: event.lensZoom,
        canSave: _canSave(state.name, event.lensZoom),
      ),
    );
  }

  Future<void> _onSave(EquipmentProfileSaveEvent _, Emitter emit) async {
    emit(state.copyWith(isLoading: true));
    if (_isEdit) {
      await profilesProvider.addProfile(
        EquipmentProfile(
          id: const Uuid().v1(),
          name: state.name,
          apertureValues: state.apertureValues,
          ndValues: state.ndValues,
          shutterSpeedValues: state.shutterSpeedValues,
          isoValues: state.isoValues,
          lensZoom: state.lensZoom,
        ),
      );
    } else {
      await profilesProvider.updateProfile(
        EquipmentProfile(
          id: _originalEquipmentProfile.id,
          name: state.name,
          apertureValues: state.apertureValues,
          ndValues: state.ndValues,
          shutterSpeedValues: state.shutterSpeedValues,
          isoValues: state.isoValues,
          lensZoom: state.lensZoom,
        ),
      );
    }
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _onDelete(EquipmentProfileDeleteEvent _, Emitter emit) async {
    emit(state.copyWith(isLoading: true));
    await profilesProvider.deleteProfile(_newEquipmentProfile);
    emit(state.copyWith(isLoading: false));
  }

  bool _canSave(String name, double? exponent) {
    return name.isNotEmpty && exponent != null && _newEquipmentProfile != _originalEquipmentProfile;
  }
}
