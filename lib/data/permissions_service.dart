import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  Future<PermissionStatus> checkCameraPermission() async => Permission.camera.status;

  Future<PermissionStatus> requestCameraPermission() async => Permission.camera.request();
}
