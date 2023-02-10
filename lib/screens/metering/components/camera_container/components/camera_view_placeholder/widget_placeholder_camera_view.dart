import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/camera_container/models/camera_error_type.dart';

class CameraViewPlaceholder extends StatelessWidget {
  final CameraErrorType? error;

  const CameraViewPlaceholder({required this.error, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.borderRadiusM)),
      child: Center(
        child: error != null ? const Icon(Icons.no_photography) : const CircularProgressIndicator(),
      ),
    );
  }
}
