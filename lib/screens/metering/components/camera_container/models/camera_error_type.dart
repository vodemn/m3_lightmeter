import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';

enum CameraErrorType { noCamerasDetected, permissionNotGranted, other }

extension CameraErrorTypeString on CameraErrorType {
  String toStringLocalized(BuildContext context) {
    switch (this) {
      case CameraErrorType.noCamerasDetected:
        return S.of(context).noCamerasDetected;
      case CameraErrorType.permissionNotGranted:
        return S.of(context).noCameraPermission;
      default:
        return S.of(context).otherCameraError;
    }
  }
}
