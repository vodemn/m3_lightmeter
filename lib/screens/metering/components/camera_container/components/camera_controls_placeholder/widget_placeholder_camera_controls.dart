import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/camera_container/models/camera_error_type.dart';

class CameraControlsPlaceholder extends StatelessWidget {
  final CameraErrorType error;
  final VoidCallback onReset;

  const CameraControlsPlaceholder({
    required this.error,
    required this.onReset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onReset,
          icon: Icon(error == CameraErrorType.permissionNotGranted ? Icons.settings_outlined : Icons.sync_outlined),
        ),
        const SizedBox(height: Dimens.grid8),
        Text(
          error.toStringLocalized(context),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
