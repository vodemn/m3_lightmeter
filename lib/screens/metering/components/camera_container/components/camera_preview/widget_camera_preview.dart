import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/camera_container/components/camera_preview/components/camera_view/widget_camera_view.dart';
import 'package:lightmeter/screens/metering/components/camera_container/components/camera_preview/components/camera_view_placeholder/widget_placeholder_camera_view.dart';
import 'package:lightmeter/screens/metering/components/camera_container/components/camera_preview/components/histogram/widget_histogram.dart';
import 'package:lightmeter/screens/metering/components/camera_container/models/camera_error_type.dart';

class CameraPreview extends StatefulWidget {
  final CameraController? controller;
  final CameraErrorType? error;

  const CameraPreview({this.controller, this.error, super.key});

  @override
  State<CameraPreview> createState() => _CameraPreviewState();
}

class _CameraPreviewState extends State<CameraPreview> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: PlatformConfig.cameraPreviewAspectRatio,
      child: Center(
        child: Stack(
          children: [
            const CameraViewPlaceholder(error: null),
            AnimatedSwitcher(
              duration: Dimens.switchDuration,
              child: widget.controller != null
                  ? _CameraPreviewBuilder(controller: widget.controller!)
                  : CameraViewPlaceholder(error: widget.error),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraPreviewBuilder extends StatefulWidget {
  final CameraController controller;

  const _CameraPreviewBuilder({required this.controller});

  @override
  State<_CameraPreviewBuilder> createState() => _CameraPreviewBuilderState();
}

class _CameraPreviewBuilderState extends State<_CameraPreviewBuilder> {
  late final ValueNotifier<bool> _initializedNotifier =
      ValueNotifier<bool>(widget.controller.value.isInitialized);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_update);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);
    _initializedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (PlatformConfig.cameraStubImage.isNotEmpty) {
      return Image.asset(PlatformConfig.cameraStubImage);
    }
    return ValueListenableBuilder<bool>(
      valueListenable: _initializedNotifier,
      builder: (context, value, child) => value
          ? Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CameraView(controller: widget.controller),
                if (UserPreferencesProvider.meteringScreenFeatureOf(
                  context,
                  MeteringScreenLayoutFeature.histogram,
                ))
                  Positioned(
                    left: Dimens.grid8,
                    right: Dimens.grid8,
                    bottom: Dimens.grid16,
                    child: CameraHistogram(controller: widget.controller),
                  ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  void _update() {
    _initializedNotifier.value = widget.controller.value.isInitialized;
  }
}
