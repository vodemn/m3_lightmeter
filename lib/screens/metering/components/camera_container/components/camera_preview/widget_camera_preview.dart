import 'package:camera/camera.dart' as camera;
import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/camera_feature.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/camera_container/components/camera_preview/components/camera_spot_detector/widget_camera_spot_detector.dart';
import 'package:lightmeter/screens/metering/components/camera_container/components/camera_preview/components/camera_view_placeholder/widget_placeholder_camera_view.dart';
import 'package:lightmeter/screens/metering/components/camera_container/components/camera_preview/components/histogram/widget_histogram.dart';
import 'package:lightmeter/screens/metering/components/camera_container/models/camera_error_type.dart';
import 'package:lightmeter/utils/context_utils.dart';

class CameraPreview extends StatefulWidget {
  final camera.CameraController? controller;
  final CameraErrorType? error;
  final ValueChanged<Offset?> onSpotTap;

  const CameraPreview({
    this.controller,
    this.error,
    required this.onSpotTap,
    super.key,
  });

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
                  ? _CameraPreviewBuilder(
                      controller: widget.controller!,
                      onSpotTap: widget.onSpotTap,
                    )
                  : CameraViewPlaceholder(error: widget.error),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraPreviewBuilder extends StatefulWidget {
  final camera.CameraController controller;
  final ValueChanged<Offset?> onSpotTap;

  const _CameraPreviewBuilder({
    required this.controller,
    required this.onSpotTap,
  });

  @override
  State<_CameraPreviewBuilder> createState() => _CameraPreviewBuilderState();
}

class _CameraPreviewBuilderState extends State<_CameraPreviewBuilder> {
  late final ValueNotifier<bool> _initializedNotifier = ValueNotifier<bool>(widget.controller.value.isInitialized);

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
      return Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              PlatformConfig.cameraStubImage,
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    }
    return ValueListenableBuilder<bool>(
      valueListenable: _initializedNotifier,
      builder: (context, value, _) => value
          ? camera.CameraPreview(
              widget.controller,
              child: context.isPro
                  ? _ProFeaturesOverlay(
                      controller: widget.controller,
                      onSpotTap: widget.onSpotTap,
                    )
                  : const SizedBox.shrink(),
            )
          : const SizedBox.shrink(),
    );
  }

  void _update() {
    _initializedNotifier.value = widget.controller.value.isInitialized;
  }
}

class _ProFeaturesOverlay extends StatelessWidget {
  final camera.CameraController controller;
  final ValueChanged<Offset?> onSpotTap;

  const _ProFeaturesOverlay({
    required this.controller,
    required this.onSpotTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasHistogram = UserPreferencesProvider.cameraFeatureOf(
      context,
      CameraFeature.histogram,
    );
    final bool hasSpotMetering = UserPreferencesProvider.cameraFeatureOf(
      context,
      CameraFeature.spotMetering,
    );
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (hasHistogram)
          Positioned(
            left: Dimens.grid8,
            right: Dimens.grid8,
            bottom: Dimens.grid16,
            child: CameraHistogram(controller: controller),
          ),
        if (hasSpotMetering) CameraSpotDetector(onSpotTap: onSpotTap),
      ],
    );
  }
}
