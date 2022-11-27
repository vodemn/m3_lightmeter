import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'event_permissions_check.dart';
import 'state_permissions_check.dart';

class PermissionsCheckBloc extends Bloc<PermissionsCheckEvent, PermissionsCheckState> {
  final PermissionsService _permissionsService;

  PermissionsCheckBloc(this._permissionsService) : super(const LoadingState()) {
    on<PermissionsGrantedEvent>((event, emit) => emit(const PermissionsGrantedState()));
    on<PermissionsDeniedEvent>((event, emit) => emit(const PermissionsDeniedState()));
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    _permissionsService.checkCameraPermission().then((value) {
      switch (value) {
        case PermissionStatus.permanentlyDenied:
        case PermissionStatus.restricted:
          add(const PermissionsDeniedEvent());
          break;
        case PermissionStatus.denied:
          _permissionsService.requestCameraPermission().then((value) {
            switch (value) {
              case PermissionStatus.permanentlyDenied:
              case PermissionStatus.restricted:
              case PermissionStatus.denied:
                add(const PermissionsDeniedEvent());
                break;
              case PermissionStatus.limited:
              case PermissionStatus.granted:
                add(const PermissionsGrantedEvent());
                break;
            }
          });
          break;
        case PermissionStatus.limited:
        case PermissionStatus.granted:
          add(const PermissionsGrantedEvent());
          break;
      }
    });
  }
}
