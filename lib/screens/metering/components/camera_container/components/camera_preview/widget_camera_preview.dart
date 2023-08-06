import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/providers/metering_screen_layout_provider.dart';
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
                  ? ValueListenableBuilder<CameraValue>(
                      valueListenable: widget.controller!,
                      builder: (_, __, ___) => widget.controller!.value.isInitialized
                          ? Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                CameraView(controller: widget.controller!),
                                if (MeteringScreenLayout.featureOf(
                                  context,
                                  MeteringScreenLayoutFeature.histogram,
                                ))
                                  Positioned(
                                    left: Dimens.grid8,
                                    right: Dimens.grid8,
                                    bottom: Dimens.grid16,
                                    child: CameraHistogram(controller: widget.controller!),
                                  ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    )
                  : CameraViewPlaceholder(error: widget.error),
            ),
          ],
        ),
      ),
    );
  }
}
