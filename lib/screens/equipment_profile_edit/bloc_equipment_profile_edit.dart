import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/screens/equipment_profile_edit/event_equipment_profile_edit.dart';
import 'package:lightmeter/screens/equipment_profile_edit/state_equipment_profile_edit.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:uuid/uuid.dart';

sealed class IEquipmentProfileEditBloc<T extends IEquipmentProfile>
    extends Bloc<IEquipmentProfileEditEvent<T>, EquipmentProfileEditState<T>> {
  @protected
  final EquipmentProfilesProviderState profilesProvider;
  @protected
  final T originalEquipmentProfile;
  @protected
  final bool isEdit;

  IEquipmentProfileEditBloc(
    this.profilesProvider, {
    required T profile,
    required this.isEdit,
  })  : originalEquipmentProfile = profile,
        super(
          EquipmentProfileEditState<T>(
            profile: profile,
            canSave: false,
          ),
        ) {
    on<IEquipmentProfileEditEvent<T>>(mapEventToState);
  }

  @protected
  @mustCallSuper
  Future<void> mapEventToState(IEquipmentProfileEditEvent<T> event, Emitter emit) async {
    switch (event) {
      case EquipmentProfileSaveEvent():
        await _onSave(event, emit);
      case EquipmentProfileCopyEvent():
        await _onCopy(event, emit);
      case EquipmentProfileDeleteEvent():
        await _onDelete(event, emit);
      default:
    }
  }

  @protected
  Future<T> createProfile(String id);

  @protected
  void emitProfile(T profile, Emitter emit) {
    emit(
      state.copyWith(
        profile: profile,
        canSave: _canSave(profile),
      ),
    );
  }

  Future<void> _onSave(EquipmentProfileSaveEvent<T> _, Emitter emit) async {
    emit(state.copyWith(isLoading: true));
    final profileId = isEdit ? originalEquipmentProfile.id : const Uuid().v1();
    final newProfile = await createProfile(profileId);
    assert(newProfile.id == profileId, 'The new profile id must be the same as the original profile id');
    await profilesProvider.addProfile(newProfile);
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _onCopy(EquipmentProfileCopyEvent<T> _, Emitter emit) async {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(isLoading: false, profileToCopy: state.profile));
  }

  Future<void> _onDelete(EquipmentProfileDeleteEvent<T> _, Emitter emit) async {
    emit(state.copyWith(isLoading: true));
    await profilesProvider.deleteProfile(originalEquipmentProfile);
    emit(state.copyWith(isLoading: false));
  }

  bool _canSave(T profile) => profile != originalEquipmentProfile;
}

class EquipmentProfileEditBloc extends IEquipmentProfileEditBloc<EquipmentProfile> {
  EquipmentProfileEditBloc(
    super.profilesProvider, {
    required super.profile,
    required super.isEdit,
  });

  @override
  Future<void> mapEventToState(IEquipmentProfileEditEvent<EquipmentProfile> event, Emitter emit) async {
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
      case final EquipmentProfileExposureOffsetChangedEvent e:
        await _onExposureOffsetChanged(e, emit);
      default:
        return super.mapEventToState(event, emit);
    }
  }

  @override
  Future<EquipmentProfile> createProfile(String id) async {
    return EquipmentProfile(
      id: id,
      name: state.profile.name,
      apertureValues: state.profile.apertureValues,
      shutterSpeedValues: state.profile.shutterSpeedValues,
      isoValues: state.profile.isoValues,
      ndValues: state.profile.ndValues,
      lensZoom: state.profile.lensZoom,
      exposureOffset: state.profile.exposureOffset,
    );
  }

  Future<void> _onNameChanged(EquipmentProfileNameChangedEvent event, Emitter emit) async {
    emitProfile(state.profile.copyWith(name: event.name), emit);
  }

  Future<void> _onApertureValuesChanged(EquipmentProfileApertureValuesChangedEvent event, Emitter emit) async {
    emitProfile(state.profile.copyWith(apertureValues: event.apertureValues), emit);
  }

  Future<void> _onShutterSpeedValuesChanged(EquipmentProfileShutterSpeedValuesChangedEvent event, Emitter emit) async {
    emitProfile(state.profile.copyWith(shutterSpeedValues: event.shutterSpeedValues), emit);
  }

  Future<void> _onIsoValuesChanged(EquipmentProfileIsoValuesChangedEvent event, Emitter emit) async {
    emitProfile(state.profile.copyWith(isoValues: event.isoValues), emit);
  }

  Future<void> _onNdValuesChanged(EquipmentProfileNdValuesChangedEvent event, Emitter emit) async {
    emitProfile(state.profile.copyWith(ndValues: event.ndValues), emit);
  }

  Future<void> _onLensZoomChanged(EquipmentProfileLensZoomChangedEvent event, Emitter emit) async {
    emitProfile(state.profile.copyWith(lensZoom: event.lensZoom), emit);
  }

  Future<void> _onExposureOffsetChanged(EquipmentProfileExposureOffsetChangedEvent event, Emitter emit) async {
    emitProfile(state.profile.copyWith(exposureOffset: event.exposureOffset), emit);
  }
}

class PinholeEquipmentProfileEditBloc extends IEquipmentProfileEditBloc<PinholeEquipmentProfile> {
  PinholeEquipmentProfileEditBloc(
    super.profilesProvider, {
    required super.profile,
    required super.isEdit,
  });

  @override
  Future<void> mapEventToState(IEquipmentProfileEditEvent<PinholeEquipmentProfile> event, Emitter emit) async {
    switch (event) {
      case final EquipmentProfileNameChangedEvent e:
        await _onNameChanged(e, emit);
      case final EquipmentProfileApertureValuesChangedEvent e:
        await _onApertureValuesChanged(e, emit);
      case final EquipmentProfileLensZoomChangedEvent e:
        await _onLensZoomChanged(e, emit);
      case final EquipmentProfileExposureOffsetChangedEvent e:
        await _onExposureOffsetChanged(e, emit);
      default:
        return super.mapEventToState(event, emit);
    }
  }

  @override
  Future<PinholeEquipmentProfile> createProfile(String id) async {
    return PinholeEquipmentProfile(
      id: id,
      name: state.profile.name,
      aperture: state.profile.aperture,
      isoValues: state.profile.isoValues,
      lensZoom: state.profile.lensZoom,
      exposureOffset: state.profile.exposureOffset,
    );
  }

  Future<void> _onNameChanged(EquipmentProfileNameChangedEvent event, Emitter emit) async {
    emitProfile(state.profile.copyWith(name: event.name), emit);
  }

  Future<void> _onApertureValuesChanged(EquipmentProfileApertureValuesChangedEvent event, Emitter emit) async {
    //emitProfile(state.profile.copyWith(apertureValues: event.apertureValues), emit);
  }

  Future<void> _onLensZoomChanged(EquipmentProfileLensZoomChangedEvent event, Emitter emit) async {
    emitProfile(state.profile.copyWith(lensZoom: event.lensZoom), emit);
  }

  Future<void> _onExposureOffsetChanged(EquipmentProfileExposureOffsetChangedEvent event, Emitter emit) async {
    emitProfile(state.profile.copyWith(exposureOffset: event.exposureOffset), emit);
  }
}
